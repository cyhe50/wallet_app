module Gateway::TrustCommerce
  class Base
    ActiveMerchant::Billing::Base.mode = :test

    attr_reader :gateway

    def initialize
      @gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
                  :login => ENV['TRUST_COMMERCE_GATEWAY_LOGIN'],
                  :password => ENV['TRUST_COMMERCE_GATEWAY_PWD'])
    end

    def authorize(amount, creditcard)
      # change amount as interger in cent
      amount *= 100

      auth_json = gateway.authorize(amount, creditcard).to_json
      Response.new(auth_json)
    end

    def capture(amount, authorization)
      # change amount as integer in cent
      amount *= 100

      cap_json = gateway.capture(amount, authorization).to_json
      Response.new(cap_json)
    end

    def refund(amount, transaction_id)
      amount *= 100

      refund_json = gateway.refund(amount, transaction_id).to_json
      Response.new(refund_json)
    end
  end
end
