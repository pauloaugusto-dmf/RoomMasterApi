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
require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    describe 'associations' do
      it { expect(belong_to(:room)) }
      it { expect(belong_to(:user)) }
    end

    describe 'presence of' do
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }
    end
  end
end
