FactoryBot.define do
  factory :account do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Number.number(digits: 6).to_s }

    trait :with_balance do
      after(:create) do |account|
        create(
          :transaction,
          account_id: account.id,
          destination_account_id: account.id,
          amount: Faker::Number.number(digits: 3)
        )
      end
    end
  end
end
