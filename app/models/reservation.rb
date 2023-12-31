# == Schema Information
#
# Table name: reservations
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  start_time :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_reservations_on_room_id  (room_id)
#  index_reservations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#  fk_rails_...  (user_id => users.id)
#
class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  with_options presence: true do
    validates :start_time
    validates :end_time
  end

  validate :validate_start_time, :validate_end_time

  private

  def validate_start_time
    return unless start_time.present? && start_time < Time.current

    errors.add(:start_time, 'cannot be in the past')
  end

  def validate_end_time
    return unless start_time.present? && end_time.present? && end_time <= start_time

    errors.add(:end_time, 'must be greater than start time')
  end
end
