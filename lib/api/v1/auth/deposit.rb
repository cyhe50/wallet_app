class API::V1::Auth::Deposit < Grape::API
  resource :deposit do
    desc "deposit money"
    params do

    end
    post do
      body false
    end
  end
end
