class API::V1::Auth < Grape::API
  resource :auth do
    mount API::V1::Auth::Deposit
    mount API::V1::Auth::Withdraw
    mount API::V1::Auth::Transfer
    mount API::V1::Auth::Balances
  end
end
