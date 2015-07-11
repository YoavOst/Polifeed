# == Schema Information
#
# Table name: words
#
#  id          :integer          not null, primary key
#  text        :string(255)
#  chars_count :integer
#
# Indexes
#
#  index_words_on_text  (text) UNIQUE
#

require 'test_helper'

class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
