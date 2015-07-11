# == Schema Information
#
# Table name: status_descs
#
#  id         :integer          not null, primary key
#  status_id  :integer
#  desc       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_status_descs_on_status_id  (status_id)
#

require 'test_helper'

class StatusDescTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
