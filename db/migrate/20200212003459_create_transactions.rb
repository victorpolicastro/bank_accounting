class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :source_account, null: false, type: :uuid, foreign_key: { to_table: :accounts }
      t.references :destination_account, null: false, type: :uuid, foreign_key: { to_table: :accounts }
      t.numeric :amount, null: false

      t.timestamps
    end
  end
end
