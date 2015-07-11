class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :fb_status_id
      t.belongs_to :politician, index: true
      t.datetime :publish_time
      t.datetime :fb_get_time
      t.boolean :is_processed
      t.integer :tokens_count
      t.integer :word_count
      t.integer :sentences_count

      t.timestamps null: false
    end
    add_foreign_key :statuses, :politicians
  end
end
