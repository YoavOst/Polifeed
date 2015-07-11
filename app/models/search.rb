# == Schema Information
#
# Table name: searches
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  party_id      :integer
#  politician_id :integer
#  start_date    :date
#  end_date      :date
#  phrase_id     :integer
#  clique_id     :integer
#  word_id       :integer
#  is_exact      :boolean
#
# Indexes
#
#  index_searches_on_clique_id      (clique_id)
#  index_searches_on_party_id       (party_id)
#  index_searches_on_phrase_id      (phrase_id)
#  index_searches_on_politician_id  (politician_id)
#  index_searches_on_word_id        (word_id)
#

class Search < ActiveRecord::Base
  belongs_to :party
  belongs_to :politician
  belongs_to :phrase
  belongs_to :clique
  belongs_to :word
  
  attr_reader :phrase_text
  attr_reader :word_text
    
  def statuses
    @statuses ||= find_statuses
  end
  
  def phrase_text=(some_string)
    update(:phrase => Phrase.find_or_create_by(:text => some_string)) unless some_string.empty?
  end
  
  def word_text=(some_string)
    update(:word => Word.find_or_create_by(:text => some_string)) unless some_string.empty?
  end
  
  private
    
    def find_statuses          
      # Basic Search
      @statuses = Status.order(:publish_time => :desc)
      @statuses = @statuses.where("publish_time > ?", "#{start_date.to_datetime}") if (start_date.present?)
      @statuses = @statuses.where("publish_time < ?", "#{end_date.tomorrow.to_datetime}") if (end_date.present?)
      @statuses = @statuses.joins(:politician).where("politician_id = ?", "#{politician_id}") if politician_id.present?
      @statuses = @statuses.joins(:politician).where("party_id = ?", "#{party_id}") if (party_id.present? && !politician_id.present?)

      # Complex search
      @statuses = @statuses.joins(word.statuses_sql) if (!word.nil?)
      @statuses = @statuses.joins(phrase.statuses_sql) if (!phrase.nil?)
      
      @statuses     
    end
    
end
