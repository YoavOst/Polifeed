# == Schema Information
#
# Table name: cliques
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Clique < ActiveRecord::Base
  
  has_and_belongs_to_many  :words
  attr_reader :word_tokens
  
  def word_tokens=(tokens)
    update(:word_ids => Word.ids_from_tokens(tokens))
  end
  
  def statuses_sql
    @statuses = find_statuses_join
  end
  
  private
    
  def find_statuses_join
    @select_clause = "words_ix.status_id"

    @from_clause = "status_indices as words_ix"

    @where_clause = "words_ix.word_id in (#{word_ids.join(",")})"
     
    @sql = "select #{@select_clause} from (#{@from_clause}) where (#{@where_clause})"    
    @sql_for_join = "inner join ( #{@sql} ) as words_t on statuses.id = words_t.status_id"    
  end


end
