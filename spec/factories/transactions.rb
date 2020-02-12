FactoryBot.define do
  factory :transaction do
    source_account { create :account }
    destination_account { create :account }
    amount { Faker::Number.decimal(l_digits: 2) }
  end
end
