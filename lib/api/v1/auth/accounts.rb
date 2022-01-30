class API::V1::Auth::Accounts < Grape::API
  resource :accounts do
    desc "balances money"
    get do
      present :accounts, current_user.accounts, with: API::V1::Entities::Accounts
    end

    desc "specific currency account"
    route_param :currency do
      get do
        raise_error(403, 'Not a valid currency') unless Account.currencies.keys.include?(params[:currency])
        present :account, current_user.send("#{params[:currency]}_account"), with: API::V1::Entities::Accounts
      end
    end
  end
end
