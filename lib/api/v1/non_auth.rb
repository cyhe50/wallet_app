class API::V1::NonAuth < Grape::API
  resource :non_auth do
    # TODO: add authenticate constraint
    # mount API::V1::NonAuth::Login
    # mount API::V1::NonAuth::Signup
  end
end
