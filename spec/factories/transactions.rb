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
FactoryBot.define do
  factory :transaction do
    amount { 100.0 }
    currency { "usd" }

    trait :purchase_action do
      action { "purchase" }
    end

    trait :refund_action do
      action { "refund" }
    end

    trait :success do
      aasm_state { "success" }
    end

    trait :failed do
      aasm_state { "failed" }
    end

    trait :with_account do
      association :account
    end

    trait :with_user do
      association :user
    end
  end
end
