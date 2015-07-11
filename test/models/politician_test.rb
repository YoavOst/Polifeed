# == Schema Information
#
# Table name: politicians
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)
#  fb_page             :string(255)
#  last_refresh_time   :datetime
#  party_id            :integer
#  location_20         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#
# Indexes
#
#  index_politicians_on_party_id  (party_id)
#

require 'test_helper'

class PoliticianTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
