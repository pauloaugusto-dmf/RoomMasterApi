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
    let(:reservation) { build(:reservation) }

    describe 'associations' do
      it { expect(belong_to(:room)) }
      it { expect(belong_to(:user)) }
    end

    describe 'presence of' do
      it { should validate_presence_of(:start_time) }
      it { should validate_presence_of(:end_time) }
    end

    context 'when start_time is in the past' do
      it 'is not valid' do
        reservation.start_time = 1.day.ago
        expect(reservation).not_to be_valid
        expect(reservation.errors[:start_time]).to include("cannot be in the past")
      end
    end

    context 'when end_time is less than or equal to start_time' do
      it 'is not valid' do
        reservation.start_time = Time.current + 1.hour
        reservation.end_time = reservation.start_time
        expect(reservation).not_to be_valid
        expect(reservation.errors[:end_time]).to include("must be greater than start time")

        reservation.end_time = reservation.start_time - 1.hour
        expect(reservation).not_to be_valid
        expect(reservation.errors[:end_time]).to include("must be greater than start time")
      end
    end

    context 'when start_time and end_time are valid' do
      it 'is valid' do
        reservation.start_time = Time.current + 1.hour
        reservation.end_time = reservation.start_time + 2.hour
        expect(reservation).to be_valid
      end
    end
  end
end
