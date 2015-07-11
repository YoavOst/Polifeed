class CreateStatusDescs < ActiveRecord::Migration
  def change
    create_table :status_descs do |t|
      t.belongs_to :status, index: true
      t.text :desc

      t.timestamps null: false
    end
    add_foreign_key :status_descs, :statuses
  end
end
