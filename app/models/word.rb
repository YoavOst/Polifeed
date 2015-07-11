# == Schema Information
#
# Table name: words
#
#  id          :integer          not null, primary key
#  text        :string(255)
#  chars_count :integer
#  first_char  :char
#  is_clean    :boolean
#
# Indexes
#
#  index_words_on_text  (text) UNIQUE
#

class Word < ActiveRecord::Base
  has_many      :status_indices
  has_many      :statuses,          through:  :status_indices
  belongs_to       :clean_word,        :class_name => :Word, foreign_key: "clean_word"

  after_create  :set_metadata, unless: :is_link?
  
  SPECIAL_CHARS =         "\(\)\{\}\<\>\"\״\'\׳\“\,\.\*\-\=\:\+\;\?\!\@\#\$\%\^\&\\\/\₪\\[\\]"
  
  def statuses_index
    @index = StatusIndex.where(:word => self).order(:status_id, :abs_position, :sen_num, :sen_position)
    
    @index |= StatusIndex.joins(:word).where("words.clean_word = ?", id).order(:status_id, :abs_position, :sen_num, :sen_position) if is_clean?  
  
    @index |= @index
  end
    
  def statuses_sql
    @statuses = find_statuses_join
  end  
  
  def self.tokens(query)
    @cleanup_chars = "\*\?\|\(\)\/\\\\"       
    @words = Word.where("text like ? and is_clean = ? and text not REGEXP ?", "%#{query}%", true, /[#{@cleanup_chars}]/.source)
    if @words.empty?
      [{id: "<<<#{query}>>>", text: "חדש: \"#{query}\""}]
    else
      @words
    end
  end
  
  def self.first_char(char)
    @words = where(:first_char => char, :is_link => false).group(:text)
  end
  
  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(text: $1, is_clean: true).id }
    tokens.split(',')
  end
  
  def self.ids_from_string(long_string)
    long_string.split(" ").map{ |w| Word.find_or_create_by(text: w, is_clean: true).id }
  end
  
  def self.most_common(number)
    Word.select("id, text, count(status_id) as amount").where(:is_clean => true, :is_link => false).joins(:status_indices).group(:id).order("amount desc").limit(number)
  end
  
  def self.longest_words(number)
    Word.where(:is_clean => true, :is_link => false).order("chars_count desc").limit(number)
  end
  
  private
    
  def find_statuses_join
    @select_clause = "words_ix.status_id"

    @from_clause = "status_indices as words_ix"

    @where_clause = "words_ix.word_id = #{id}"
     
    @sql = "select #{@select_clause} from (#{@from_clause}) where (#{@where_clause})"    
    @sql_for_join = "inner join ( #{@sql} ) as words_t on statuses.id = words_t.status_id"    
  end
  
  def set_metadata
    @temp_word = String.new(text.to_s)
    @is_clean = true
    @clean_word = nil
    while !(@temp_word.sub!(/^[#{SPECIAL_CHARS}]/, '')).nil? do end
    while !(@temp_word.sub!(/[#{SPECIAL_CHARS}]$/, '')).nil? do end
    
    if @temp_word.to_s != text.to_s then
      @is_clean = false
      @clean_word = Word.find_or_create_by(text: @temp_word)         
    end

    self.update_columns(:chars_count => text.length, :first_char => text[0], :is_clean => @is_clean, :clean_word => @clean_word)

  end  
end
