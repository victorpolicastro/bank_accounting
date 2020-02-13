class AccountPresenter
  include ActionView::Helpers

  def initialize(account)
    @account = account.is_a?(Account) ? account : Account.find(account)
  end

  def call
    {
      current_balance: number_to_currency(
        account.current_balance,
        unit: 'R$ ',
        separator: ',',
        delimiter: '.'
      )
    }
  end

  private

  attr_accessor :account
end
