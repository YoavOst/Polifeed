class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.belongs_to :party, index: true
      t.belongs_to :politician, index: true
      t.date :start_date
      t.date :end_date
      t.belongs_to :phrase, index: true
      t.belongs_to :clique, index: true
    end
    add_foreign_key :searches, :parties
    add_foreign_key :searches, :politicians
    add_foreign_key :searches, :phrases
    add_foreign_key :searches, :cliques
  end
end
