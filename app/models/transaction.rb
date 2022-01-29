# == Schema Information
#
# Table name: transactions
#
#  id             :integer          not null, primary key
#  aasm_state     :integer
#  action         :integer
#  amount         :float            default(0.0)
#  currency       :integer
#  raw_data       :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  transaction_id :string
#  user_id        :integer
#
# Indexes
#
#  index_transactions_on_account_id  (account_id)
#  index_transactions_on_user_id     (user_id)
#
class Transaction < ApplicationRecord
  include Transaction::AasmState

  belongs_to :user
  belongs_to :account
  counter_culture :account, column_name: 'balance', delta_column: 'amount'

  enum action: { purchase: 0, refund: 1 }
  enum currency: Account.currencies
end
