class Transaction < ApplicationRecord
  validates :account_id, :destination_account_id, :amount, presence: true

  has_one :account
end
