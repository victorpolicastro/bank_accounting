class Account < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, presence: true
  validates :name, presence: true

  has_many :transactions

  def current_balance
    down = self.transactions.sum(:amount).to_f
    up = Transaction.where(destination_account_id: self.id).sum(:amount).to_f

    up - down
  end
end
