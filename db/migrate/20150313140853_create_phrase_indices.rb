class CreatePhraseIndices < ActiveRecord::Migration
  def change
    create_table :phrase_indices do |t|
      t.belongs_to :phrase
      t.integer :abs_position
      t.belongs_to :word
    end
    add_foreign_key :phrase_indices, :phrases
    add_foreign_key :phrase_indices, :words
  end
end
