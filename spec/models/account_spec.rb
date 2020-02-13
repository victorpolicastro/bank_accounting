require 'rails_helper'

RSpec.describe Account, type: :model do
  context 'validation specs' do
    it 'ensures name presence' do
      base_transaction = Account.new(
        name: nil,
        email: Faker::Internet.email,
        password: Faker::Number.number(digits: 6).to_s
      ).save

      expect(base_transaction).to(be(false))
    end

    it 'ensures email presence' do
      password = Faker::Number.number(digits: 6).to_s

      base_transaction = Account.new(
        name: Faker::Name.name,
        email: nil,
        password: Faker::Number.number(digits: 6).to_s,
      ).save

      expect(base_transaction).to(be(false))
    end

    it 'ensures password presence' do
      base_transaction = Account.new(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: nil
      ).save

      expect(base_transaction).to(be(false))
    end
  end

  context 'when valid' do
    it 'succesfully saves the account' do
      base_transaction = Account.new(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Number.number(digits: 6).to_s
      ).save

      expect(base_transaction).to(be(true))
    end
  end

  context 'when account has balance' do
    let!(:account) { create :account, :with_balance }

    it "successfully returns account's balance" do
      expect(account.current_balance.positive?).to(be(true))
    end
  end
end
