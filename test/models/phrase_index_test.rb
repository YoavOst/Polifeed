# == Schema Information
#
# Table name: phrase_indices
#
#  id           :integer          not null, primary key
#  phrase_id    :integer
#  abs_position :integer
#  word_id      :integer
#
# Indexes
#
#  fk_rails_6731030c3e  (word_id)
#  fk_rails_ec9d3d1f15  (phrase_id)
#

require 'test_helper'

class PhraseIndexTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
