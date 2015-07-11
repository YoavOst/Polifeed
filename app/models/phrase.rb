# == Schema Information
#
# Table name: phrases
#
#  id         :integer          not null, primary key
#  text       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Phrase < ActiveRecord::Base
  has_and_belongs_to_many     :words,         :join_table => :phrase_indices
  after_create  :build_words_index
  
  def statuses_sql
#    @statuses = find_statuses_subselect
    @statuses = find_statuses_join
  end
  
  private
  
  def build_words_index
    if !(text.nil? || text.empty?) then
      @ids = Word.ids_from_string(text)
      @index_records = @ids.map.with_index(1) { |w_id,i| { :phrase_id => id, :abs_position => i, :word_id => w_id } }
      PhraseIndex.create(@index_records)
    end
  end
  
  def find_statuses_join
    @range = 1..words.count

    @select_clause = "w1.st1 as status_id, w1.st_pos1 as first_word"

    @derived_tables = @range.map {|i| "(select s_ix#{i}.status_id as st#{i}, s_ix#{i}.abs_position as st_pos#{i}
    from status_indices as s_ix#{i} inner join phrase_indices p_ix#{i} on s_ix#{i}.word_id = p_ix#{i}.word_id
    where p_ix#{i}.abs_position = #{i} and p_ix#{i}.phrase_id = #{id}) as w#{i}"}
    @join_tables = @derived_tables.join("\n inner join \n")  
    @join_term = @range.first(@range.size-1).map {|i| "w#{i}.st#{i} = w#{i+1}.st#{i+1}"}.join(" and ")
    @from_clause = "#{@join_tables} on #{@join_term}"

    @where_clause = @range.first(@range.size-1).map {|i| "w#{i}.st_pos#{i}+1 = w#{i+1}.st_pos#{i+1}"}.join(" and ") 
     
    @sql = "select #{@select_clause} from (#{@from_clause}) where (#{@where_clause})"    
    @sql_for_join = "inner join ( #{@sql} ) as phrases_t on statuses.id = phrases_t.status_id"
  end
  
  def find_statuses_subselect
    @range = 2..words.count

    @main_select = "select s_ix1.status_id as status_id, s_ix1.abs_position as first_word 
                    from status_indices as s_ix1 inner join phrase_indices p_ix1 on s_ix1.word_id=p_ix1.word_id 
                    where p_ix1.abs_position = 1 and p_ix1.phrase_id = #{id} and s_ix1.status_id in " 

    @mid_selects = @range.first(@range.size-1).map{|i|"\n(select s_ix#{i}.status_id
     from status_indices as s_ix#{i} inner join phrase_indices p_ix#{i} on s_ix#{i}.word_id=p_ix#{i}.word_id
     where 
        p_ix#{i}.phrase_id = #{id} and 
        p_ix#{i}.abs_position = #{i} and 
        s_ix#{i}.status_id = s_ix#{i-1}.status_id and 
        s_ix#{i}.abs_position = s_ix#{i-1}.abs_position + 1
        and s_ix#{i}.status_id in "}.join()    

    @last_select = "\n(select s_ix#{words.count}.status_id
                   from status_indices as s_ix#{words.count} inner join phrase_indices p_ix#{words.count} on 
                   s_ix#{words.count}.word_id=p_ix#{words.count}.word_id
                   where 
                      p_ix#{words.count}.phrase_id = #{id} and 
                      p_ix#{words.count}.abs_position = #{words.count} and 
                      s_ix#{words.count}.status_id = s_ix#{words.count-1}.status_id and 
                      s_ix#{words.count}.abs_position = s_ix#{words.count-1}.abs_position + 1" + ")"*@range.size
    
    @sql = @main_select + @mid_selects + @last_select 
    @statuses = Phrase.connection.select_all(@sql)                                          
  end
  
end
