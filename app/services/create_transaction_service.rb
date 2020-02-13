class CreateTransactionService
  include ActiveModel::Validations

  validates :account, :destination_account, :amount, presence: true

  def initialize(account, destination_account, amount)
    @account = account.is_a?(Account) ? account : Account.find_by(id: account)
    @destination_account = destination_account.is_a?(Account) ? destination_account : Account.find_by(id: destination_account)
    @amount = amount
  end

  def call
    return OpenStruct.new(success?: false, messages: errors.full_messages) if invalid?
    return OpenStruct.new(success?: false, messages: ['Amount has to be positive.']) unless amount.positive?
    return OpenStruct.new(success?: false, messages: ['Insufficient funds.']) unless account.current_balance.positive?

    account.transactions.create!(
      destination_account_id: destination_account.id,
      amount: amount
    )

    OpenStruct.new(success?: true, messages: ['Transaction successfully created.'])
  rescue StandardError => e
    Rails.logger.error("An error occurred while creating accounts transactions from #{account.id} to #{destination_account.id}")
    Rails.logger.error(e.backtrace.join("\n"))
    OpenStruct.new(success?: false, messages: ['An error occurred during transaction. Please, try again or contact support.'])
  end

  private

  attr_accessor :account, :destination_account, :amount
end
