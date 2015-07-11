class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :text
      t.integer :chars_count
    end
    add_index :words, :text, unique: true
  end
end
