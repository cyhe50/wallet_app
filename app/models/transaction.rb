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
#  receive_from   :integer
#  transfer_to    :integer
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
  belongs_to :transfer_to, class_name: 'User', foreign_key: 'transfer_to', optional: true
  belongs_to :receive_from, class_name: 'User', foreign_key: 'receive_from', optional: true

  counter_culture :account,
  column_name: proc { |t| t.success? ? "balance" : nil },
  delta_column: 'amount'

  enum action: { purchase: 0, refund: 1, transfer: 2, receive: 3 }
  enum currency: Account.currencies

  validate :valid_amount_price
  validate :valid_account_and_currency
  validate :enough_balance

  private

  def valid_amount_price
    case action
    when 'deposit'
      errors.add(:amount, 'should greater than 0 since it is depositing') if amount <= 0
    when 'withdraw'
      errors.add(:amount, 'should less than 0 since it is withdrawing') if amount >= 0
    when 'send'
      errors.add(:amount, 'should lesser than 0 since it is transfering to user') if transfer_to.present? && amount >= 0
    when 'receive'
      errors.add(:amount, 'should greater than 0 since it is receiving from user') if receive_from.present? && amount <= 0
    end
  end

  def valid_account_and_currency
    errors.add(:account_and_currency, 'Transfer to wrong account type') unless currency == account.currency
  end

  def enough_balance
    return if amount > 0

    cal_balance = account.balance + amount
    errors.add(:balance, 'insufficient balance') if cal_balance < 0
  end
end
