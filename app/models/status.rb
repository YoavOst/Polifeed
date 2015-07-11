# == Schema Information
#
# Table name: statuses
#
#  id              :integer          not null, primary key
#  fb_status_id    :string(255)
#  politician_id   :integer
#  publish_time    :datetime
#  fb_get_time     :datetime
#  is_processed    :boolean
#  tokens_count    :integer
#  words_count     :integer
#  sentences_count :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_statuses_on_politician_id  (politician_id)
#

class Status < ActiveRecord::Base
  belongs_to                  :politician
  has_one                     :party,         through: :politicians
  has_one                     :status_desc
  has_and_belongs_to_many     :tags
  has_many                    :words,         through: :status_indices
  has_many                    :status_indices
  scope                       :unprocessed, ->  { where(:is_processed => false) }
  scope                       :processed,   ->  { where(:is_processed => true) }
  attr_reader :tag_tokens
  
  self.per_page = 10
  WORD_DIVIDER =         " "    
  SENTENCE_END =         "\.\?\!"
  SPECIAL_CHARS =         "\(\)\{\}\<\>\"\״\'\׳\“\,\.\*\-\=\:\+\;\?\!\@\#\$\%\^\&\\\/\₪\\[\\]"
  
  def text
    status_desc.desc
  end

  def text=(new_text)
    statues_desc.update!(:desc => new_text)
  end
  
  def tag_tokens=(tokens)
    update(:tag_ids => Tag.ids_from_tokens(tokens))
  end

  def summary(start, finish)
    start = 1 if start < 1
    @sum_arr = Word.select(:id, :text).joins("left join status_indices ix on words.id = ix.word_id").where("ix.status_id = ? and ix.sen_num between ? and ?", id, start, finish).order("ix.sen_num, ix.sen_position")
    
    @summary = @sum_arr.map { |w| w.text }.join(" ")
  end
  
  def process_words
    
    # Make sure the status has text and not yet processed
    if !text.nil? && !is_processed then
    
        # Save all http urls in an array and switch to single generic word
        @link = /http\S*/
        @links = text.scan(@link)
        @clean_text = String.new(text)
        @links.each_index{|i| @clean_text.sub!(@links[i],"<<<link_#{i}>>>") }
        
        @status_words = @clean_text.split(WORD_DIVIDER)
        @tokens = 0
        @sentence_count = 1
        @abs_word_count = 1
        @sen_word_count = 1
        @flaged_finished = false        
        @status_words.each do |w|       
          # Check for links
          @new_link_regex = /<<<link_(?<index>\d*)>>>/
          @match = @new_link_regex.match(w)
          if @match then
            @temp_link = Word.find_or_create_by(text: @links[@match[:index].to_i][0...255], is_clean: false, is_link: true)
            StatusIndex.create( :status => self,
                                :word => @temp_link,
                                :abs_position => @abs_word_count, 
                                :sen_num => @sentence_count, 
                                :sen_position => @sen_word_count)
            @tokens += @links[@match[:index].to_i].length
            @abs_word_count += 1
            @sentence_count += 1
            @flaged_finished = true
            @sen_word_count = 1
          else
            # Regular words
            StatusIndex.create( :status => self,
                                :word => Word.find_or_create_by(text: w),
                                :abs_position => @abs_word_count, 
                                :sen_num => @sentence_count, 
                                :sen_position => @sen_word_count)

            # Set stats
            @tokens += w.length    
            @abs_word_count += 1
            @sen_word_count += 1
            @flaged_finished = false          
            if w.end_with?(".", "!","?","\n") then
              @sentence_count += 1
              @sen_word_count = 1
              @flaged_finished = true
            end
          end
        end
        
        # Update status
        if @flaged_finished then
          update(:is_processed => true, :tokens_count => @tokens, :sentences_count => @sentence_count-1, :words_count => @abs_word_count-1)
        else
          update(:is_processed => true, :tokens_count => @tokens, :sentences_count => @sentence_count, :words_count => @abs_word_count-1)
        end
    end
  end
  
  def find_word_abs(abs_position)
    @index = status_indices.find_by(:abs_position => abs_position) 
    if @index
      @word = @index.word
    end
  end
  
  def find_word_sen(sen_num, sen_position)
    @index = status_indices.find_by(:sen_num => sen_num, :sen_position => sen_position)
    if @index
      @word = @index.word
    end
  end
  
  def self.most_words(number)
    Status.select("id, politician_id, publish_time, count(word_id) as amount").joins(:status_indices).group(:id).order("amount desc").limit(number)  
  end
  
  def self.most_chars(number)
    Status.select("status_id as id, politician_id, publish_time, count(word_id) as words_count ,sum(chars_count) as tokens").joins(status_indices: :word).group("status_id").order("tokens desc").limit(number)  
  end
  
end
