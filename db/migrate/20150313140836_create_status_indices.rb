class CreateStatusIndices < ActiveRecord::Migration
  def change
    create_table :status_indices do |t|
      t.belongs_to :status
      t.integer :abs_position
      t.belongs_to :word
      t.integer :sen_num
      t.integer :sen_position
    end
    add_foreign_key :status_indices, :statuses
    add_foreign_key :status_indices, :words
  end
end
