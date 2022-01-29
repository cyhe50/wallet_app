class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, index: true, foreign_key: true
      t.float :balance, default: 0.0
      t.integer :currency

      t.timestamps
    end
  end
end
