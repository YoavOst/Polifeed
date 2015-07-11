class CreateJoinTableTagStatus < ActiveRecord::Migration
  def change
    create_join_table :statuses, :tags do |t|
      # t.index [:status_id, :tag_id]
      # t.index [:tag_id, :status_id]
    end
  end
end
