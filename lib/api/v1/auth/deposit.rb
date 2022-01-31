class API::V1::Auth::Deposit < Grape::API
  helpers do
    def strong_creditcard_params
      strong_params = ActionController::Parameters.new(params[:creditcard])
      strong_params.permit(:month, :year, :number, :verification_value)
    end

    def creditcard_params_with_user
      strong_creditcard_params.merge!({
        first_name: current_user.first_name,
        last_name: current_user.last_name
      })
    end
  end

  resource :deposit do
    desc "deposit money"
    params do
      requires :creditcard, type: JSON do
        requires :month, type: String
        requires :year, type: String
        requires :number, type: String
        requires :verification_value, type: String
      end
      requires :amount, type: Integer
      requires :currency, type: String, values: Account.currencies.keys
    end
    post do
      begin
        service = Gateway::TrustCommerceService.new(current_user, creditcard_params_with_user)
        response = service.purchase!(params[:amount], params[:currency])
      rescue => e
        raise_error(406, e)
      end

      status 201
    end
  end
end
