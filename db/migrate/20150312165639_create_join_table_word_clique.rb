class CreateJoinTableWordClique < ActiveRecord::Migration
  def change
    create_join_table :words, :cliques do |t|
      # t.index [:word_id, :clique_id]
      # t.index [:clique_id, :word_id]
    end
  end
end
