# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  balance    :float            default(0.0)
#  currency   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
FactoryBot.define do
  factory :account do
    currency { "usd" }

    trait :with_user do
      association :user
    end
  end
end
