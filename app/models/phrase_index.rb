# == Schema Information
#
# Table name: phrase_indices
#
#  phrase_id    :integer
#  abs_position :integer
#  word_id      :integer
#
# Indexes
#
#  fk_rails_6731030c3e  (word_id)
#  fk_rails_ec9d3d1f15  (phrase_id)
#

class PhraseIndex < ActiveRecord::Base
  belongs_to :phrase
  belongs_to :word
end
