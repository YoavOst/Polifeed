# == Schema Information
#
# Table name: parties
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  knesset_seats_20 :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Party < ActiveRecord::Base
  has_many :politicians
  has_many :statuses, through: :politicians
  
  default_scope { order('knesset_seats_20 desc') }
  scope       :with_statuses, -> { where.joins(:statuses).count > 0 }
  
  private
  
end
