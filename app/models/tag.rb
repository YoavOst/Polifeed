# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  text       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_text  (text) UNIQUE
#

class Tag < ActiveRecord::Base

  has_and_belongs_to_many :statuses
  
  def self.tag_counts
    Tag.select(:id,:text, "count(tag_id) as count").joins(:statuses).group(:id)
  end
  
  def self.tokens(query)
    @tags = where("text like ?", "%#{query}%")
    if @tags.empty?
      [{id: "<<<#{query}>>>", text: "חדש: \"#{query}\""}]
    else
      @tags
    end
  end
  
  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(text: $1).id }
    tokens.split(',')
  end
  
  def self.most_common(number)
    Tag.select("tag_id as id, text, count(status_id) as amount").joins(:statuses).group(:id).order("amount desc").limit(number)
  end


end
