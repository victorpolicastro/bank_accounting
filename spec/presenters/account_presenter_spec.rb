require('rails_helper')

RSpec.describe AccountPresenter do
  include ActionView::Helpers

  context 'when account has positive balance' do
    let!(:account) { create :account, :with_balance }

    it 'expects a formatted hash' do
      data = described_class.new(account).call

      formatted_balance = number_to_currency(account.current_balance, unit: 'R$ ', separator: ',', delimiter: '.')

      expect(data[:current_balance]).to(eq(formatted_balance))
    end
  end

  context 'when account has no balance' do
    let!(:account) { create :account }

    it 'expects a formatted hash' do
      data = described_class.new(account).call

      expect(data[:current_balance]).to(eq('R$ 0,00'))
    end
  end
end
