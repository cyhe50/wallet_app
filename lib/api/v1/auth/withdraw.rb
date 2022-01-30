class API::V1::Auth::Withdraw < Grape::API
  resource :withdraw do
    desc "withdraw money"
    params do

    end
    post do
      body false
    end
  end
end
