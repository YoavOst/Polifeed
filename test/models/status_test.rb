# == Schema Information
#
# Table name: statuses
#
#  id              :integer          not null, primary key
#  fb_status_id    :string(255)
#  politician_id   :integer
#  publish_time    :datetime
#  fb_get_time     :datetime
#  is_processed    :boolean
#  tokens_count    :integer
#  words_count     :integer
#  sentences_count :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_statuses_on_politician_id  (politician_id)
#

require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
