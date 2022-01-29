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
require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
