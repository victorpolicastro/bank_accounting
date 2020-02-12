class Transaction < ApplicationRecord
  validates :source_account_id,
            :destination_account_id,
            :amount,
            presence: true
end
