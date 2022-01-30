class API::V1::Auth::Transfer < Grape::API
  resource :transfer do
    desc "transfer money to other user"
    params do

    end
    post do
      body false
    end
  end
end
