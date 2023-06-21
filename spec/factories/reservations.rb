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
FactoryBot.define do
  factory :reservation do
    user { association(:user) }
    room { association(:room) }
    start_time { 1.hour.from_now }
    end_time { 2.hours.from_now }
  end
end
