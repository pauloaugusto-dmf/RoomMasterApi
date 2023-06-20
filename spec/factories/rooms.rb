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
FactoryBot.define do
  factory :room do
    name { Faker::Name.initials }
    capacity { 1 }
  end
end
