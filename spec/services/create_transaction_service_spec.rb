require('rails_helper')

RSpec.describe CreateTransactionService do
  context 'when invalid' do
    let!(:account) { create :account }
    let!(:destination_account) { create :account }
    let(:amount) { Faker::Number.number(digits: 8) }

    it 'ensures account presence' do
      response = described_class.new(nil, destination_account, amount).call

      expect(response.success?).to(be(false))
      expect(response.messages).to(include("Account can't be blank"))
    end

    it 'ensures destination_account presence' do
      response = described_class.new(account, nil, amount).call

      expect(response.success?).to(be(false))
      expect(response.messages).to(include("Destination account can't be blank"))
    end

    it 'ensures amount presence' do
      response = described_class.new(account, destination_account, nil).call

      expect(response.success?).to(be(false))
      expect(response.messages).to(include("Amount can't be blank"))
    end

    it 'ensures amount is positive' do
      response = described_class.new(account, destination_account, -20).call

      expect(response.success?).to(be(false))
      expect(response.messages).to(include('Amount has to be positive.'))
    end

    it 'ensures account have funds' do
      response = described_class.new(account, destination_account, amount).call

      expect(response.success?).to(be(false))
      expect(response.messages).to(include('Insufficient funds.'))
    end
  end

  context 'when valid' do
    let!(:account) { create :account, :with_balance }
    let(:current_balance) { account.current_balance }
    let!(:destination_account) { create :account }
    let(:amount) { Faker::Number.number(digits: 2) }

    it 'successfully creates transaction' do
      response = described_class.new(account, destination_account, amount).call

      expect(response.success?).to(be(true))
      expect(response.messages).to(include('Transaction successfully created.'))
      expect(destination_account.current_balance).to(eq(amount))
      expect(account.current_balance).to(eq(current_balance - amount))
    end
  end
end
