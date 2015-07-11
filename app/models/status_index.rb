# == Schema Information
#
# Table name: status_indices
#
#  status_id          :integer
#  abs_position       :integer
#  clean_word_id      :integer
#  dirty_word_id      :integer
#  sen_num      :integer
#  sen_position :integer
#
# Indexes
#
#  fk_rails_21b696526a  (word_id)
#  fk_rails_6b3ac368a4  (status_id)
#

class StatusIndex < ActiveRecord::Base
  belongs_to    :status
  belongs_to    :word
end
