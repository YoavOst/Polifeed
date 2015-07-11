class AddAttachmentAvatarToPoliticians < ActiveRecord::Migration
  def self.up
    change_table :politicians do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :politicians, :avatar
  end
end
