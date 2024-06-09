FactoryBot.define do
  factory :spot do
    association :user
    name { Faker::Name.name }
    introduction { Faker::Lorem.characters(number:5) }
    latitude { 34.70246347104699 }
    longitude { 135.4955532773327 }
  end
end