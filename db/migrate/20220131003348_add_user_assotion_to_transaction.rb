class AddUserAssotionToTransaction < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :transfer_to, :integer, index: true, foreign_key: true
    add_column :transactions, :receive_from, :integer, index: true, foreign_key: true
  end
end
