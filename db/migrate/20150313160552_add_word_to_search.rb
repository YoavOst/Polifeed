class AddWordToSearch < ActiveRecord::Migration
  def change
    add_reference :searches, :word, index: true
    add_foreign_key :searches, :words
  end
end
