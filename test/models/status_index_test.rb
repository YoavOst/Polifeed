# == Schema Information
#
# Table name: status_indices
#
#  id           :integer          not null, primary key
#  status_id    :integer
#  abs_position :integer
#  word_id      :integer
#  sen_num      :integer
#  sen_position :integer
#
# Indexes
#
#  fk_rails_21b696526a  (word_id)
#  fk_rails_6b3ac368a4  (status_id)
#

require 'test_helper'

class StatusIndexTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
