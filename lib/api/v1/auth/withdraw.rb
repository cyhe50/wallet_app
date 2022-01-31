class API::V1::Auth::Withdraw < Grape::API
  resource :withdraw do
    desc "withdraw money"
    params do
      requires :amount, type: Integer
      requires :currency, type: String, values: Account.currencies.keys
    end
    post do
      account = Account.find_or_create_by!(user_id: current_user.id, currency: params[:currency])

      begin
        service = Gateway::TrustCommerceService.new(current_user)
        service.refund!(account, params[:amount])
      rescue => e
        raise_error(406, e)
      end

      status 201
    end
  end
end
