# == Schema Information
#
# Table name: searches
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  party_id      :integer
#  politician_id :integer
#  start_date    :date
#  end_date      :date
#  phrase_id     :integer
#  clique_id     :integer
#  word_id       :integer
#  is_exact      :boolean
#
# Indexes
#
#  index_searches_on_clique_id      (clique_id)
#  index_searches_on_party_id       (party_id)
#  index_searches_on_phrase_id      (phrase_id)
#  index_searches_on_politician_id  (politician_id)
#  index_searches_on_word_id        (word_id)
#

require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
