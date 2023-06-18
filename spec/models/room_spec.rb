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
require 'rails_helper'

RSpec.describe Room, type: :model do
  subject(:room) { build :room }

  describe 'validations' do
    describe 'presence of' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:capacity) }
    end
  end
end
