FactoryBot.define do
  factory :account do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Number.number(digits: 6).to_s }
  end
end
