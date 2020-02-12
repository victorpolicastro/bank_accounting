require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let!(:account) { create :account }
  let!(:destination_account) { create :account }

  context 'validation specs' do
    it 'ensures account presence' do
      base_transaction = Transaction.new(
        account_id: nil,
        destination_account_id: destination_account.id,
        amount: Faker::Number.decimal(l_digits: 2)
      ).save

      expect(base_transaction).to(eq(false))
    end

    it 'ensures account presence' do
      base_transaction = Transaction.new(
        account_id: account.id,
        destination_account_id: nil,
        amount: Faker::Number.decimal(l_digits: 2)
      ).save

      expect(base_transaction).to(eq(false))
    end

    it 'ensures account presence' do
      base_transaction = Transaction.new(
        account_id: account.id,
        destination_account_id: destination_account.id,
        amount: nil
      ).save

      expect(base_transaction).to(eq(false))
    end
  end

  context 'when valid' do
    it 'successfully saves transaction' do
      base_transaction = Transaction.new(
        account_id: account.id,
        destination_account_id: destination_account.id,
        amount: Faker::Number.decimal(l_digits: 2)
      ).save

      expect(base_transaction).to(eq(true))
    end
  end
end
