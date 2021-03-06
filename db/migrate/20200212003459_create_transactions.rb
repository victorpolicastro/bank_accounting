class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :account, null: false, type: :uuid, foreign_key: true
      t.references :destination_account, null: false, type: :uuid, foreign_key: { to_table: :accounts }
      t.numeric :amount, null: false

      t.timestamps
    end
  end
end
