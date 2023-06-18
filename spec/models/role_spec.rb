# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Role, type: :model do
  subject(:role) { build :role }

  describe 'validations' do
    describe 'presence of' do
      it { should validate_presence_of(:name) }
    end
  end
end
