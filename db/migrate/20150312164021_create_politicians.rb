class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :full_name
      t.string :fb_page
      t.datetime :last_refresh_time
      t.belongs_to :party, index: true
      t.integer :location_20

      t.timestamps null: false
    end
    add_foreign_key :politicians, :parties
  end
end
