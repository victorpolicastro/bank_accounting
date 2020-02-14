FactoryBot.define do
  factory :transaction do
    account { create :account }
    destination_account { create :account }
    amount { Faker::Number.number(digits: 2) }
  end
end
