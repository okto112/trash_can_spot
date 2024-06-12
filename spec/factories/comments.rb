FactoryBot.define do
  factory :comment do
    association :user
    association :spot
    comment { Faker::Lorem.characters(number:5) }
  end
end