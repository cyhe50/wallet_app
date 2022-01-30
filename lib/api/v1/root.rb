class API::V1::Root < Grape::API
  version  'v1'
  mount API::V1::Ping
  mount API::V1::Auth
  mount API::V1::NonAuth
end
