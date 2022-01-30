class API::V1::Auth::Balances < Grape::API
  resource :balances do
    desc "balances money"
    params do

    end
    get do
      body false
    end
  end
end
