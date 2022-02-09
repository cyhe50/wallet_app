module Gateway::TrustCommerce
  class Response
    attr_reader :response
    def initialize(raw_data)
      @response = JSON.parse(raw_data)
    end

    def transaction_id
      response['params']['transid']
    end

    def success?
      response['success']
    end

    def status
      response['params']['status']
    end

    def authorization
      response['authorization']
    end

    def message
      response['message']
    end
  end
end
