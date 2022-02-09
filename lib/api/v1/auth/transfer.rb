class API::V1::Auth::Transfer < Grape::API
  resource :transfer do
    desc "transfer money to other user"
    params do
      requires :amount, type: Integer
      requires :currency, type: String, values: Account.currencies.keys
      requires :transfer_to_id, type: Integer
    end
    post do
      transfer_to = User.find_by(id: params[:transfer_to_id])
      raise_error(404, 'Transfer User Not Found') unless transfer_to

      begin
        service = Gateway::InAppService.new(current_user, transfer_to)
        service.transfer!(params[:amount], params[:currency])
      rescue StandardError => e
        raise_error(406, e)
      end

      status 201
    end
  end
end
