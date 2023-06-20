# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  capacity   :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Room < ApplicationRecord
  has_many :reservations, dependent: :destroy

  with_options presence: true do
    validates :capacity
    validates :name
  end
end
