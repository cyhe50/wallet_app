module Gateway
  class Error < StandardError; end

  class TrustCommerceService
    attr_reader :user, :creditcard, :trust_commerce_gateway

    def initialize(user, creditcard_params)
      @user = user
      creditcard_params.merge!({ first_name: user.first_name, last_name: user.last_name})
      @creditcard = ActiveMerchant::Billing::CreditCard.new(creditcard_params)
      @trust_commerce_gateway = Gateway::TrustCommerce::Base.new
    end

    def purchase(amount, currency = 'usd')
      return false unless creditcard.validate.empty?

      ActiveRecord::Base.transaction do
        # check authorization
        auth_response = trust_commerce_gateway.authorize(amount, creditcard)
        raise Error, auth_response.message unless auth_response.success?

        # initialize account and transaction
        account = Account.find_or_create_by!(user_id: user.id, currency: currency)
        transaction = Transaction.new(
                        action: 'purchase',
                        amount: amount,
                        currency: currency,
                        raw_data: auth_response.to_json,
                        transaction_id: auth_response.transaction_id,
                        user_id: user.id,
                        account_id: account.id
                      )
        raise Error, transaction.errors.full_messages unless transaction.validate

        # capture the money and final update
        cap_response = trust_commerce_gateway.capture(amount, auth_response.authorization)
        if cap_response.success?
          transaction.raw_data = cap_response.to_json
          transaction.transaction_id = cap_response.transaction_id
          transaction.success!
        else
          transaction.raw_data = cap_response.to_json
          transaction.fail!
        end

        transaction.save!
      end
    end

    def refund(account, amount)
      return false if account.balance < amount

      refund_array = account.transactions.reverse.inject([]) do |array, transaction|
                        array << {
                          transaction_id: transaction.transaction_id,
                          amount: (transaction.amount < amount) ? transaction.amount.to_i : amount
                        }

                        amount -= transaction.amount.to_i
                        break array if amount <= 0
                        array
                     end

      ActiveRecord::Base.transaction do
        refund_array.each do |refund_data|
          response = trust_commerce_gateway.refund(refund_data[:amount], refund_data[:transaction_id])
          raise Error, response.message unless response.success?

          transaction = Transaction.create!(
                          action: 'refund',
                          transaction_id: response.transaction_id,
                          raw_data: response.to_json,
                          user_id: user.id,
                          account_id: account.id,
                          amount: -refund_data[:amount],
                          currency: account.currency
                        )

          transaction.success!
        end
      end
    end
  end
end
