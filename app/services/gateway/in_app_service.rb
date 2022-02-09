module Gateway
  class Error < StandardError; end

  class InAppService
    attr_reader :user, :transfer_to

    def initialize(user, transfer_to)
      @user = user
      @transfer_to = transfer_to
    end

    def transfer!(amount, currency = 'usd')
      account = user.send("#{currency}_account")
      raise Error, 'Account Not Found' unless account
      raise Error, 'insufficient money' unless account.balance > amount

      ActiveRecord::Base.transaction do
        transfering_transaction = Transaction.create!(
                                    action: 'transfer',
                                    user_id: user.id,
                                    account_id: account.id,
                                    amount: -amount,
                                    currency: currency,
                                    transfer_to: transfer_to
                                  )

        receiving_account = Account.find_or_create_by!(user_id: transfer_to.id, currency: currency)
        receiving_transaction = Transaction.create!(
                                  action: 'receive',
                                  user_id: transfer_to.id,
                                  account_id: receiving_account.id,
                                  amount: amount,
                                  currency: currency,
                                  receive_from: user
                                )

        receiving_transaction.success!
        transfering_transaction.success!
      end
    end
  end
end
