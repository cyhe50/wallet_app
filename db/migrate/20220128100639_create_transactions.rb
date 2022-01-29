class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :user, index: true, foreign_key: true
      t.references :account, index: true, foreeign_key: true
      t.integer :currency
      t.float :amount, default: 0.0
      t.integer :aasm_state
      t.integer :action
      t.string :transaction_id
      t.text :raw_data

      t.timestamps
    end
  end
end
