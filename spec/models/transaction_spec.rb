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
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
