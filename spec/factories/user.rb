FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.email }
  end

  password = Faker::Internet.password(min_length: 6, max_length: 8)

  factory :test_user do
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    name { Faker::Lorem.characters(number: 5) }
    is_deleted { true }
  end
end