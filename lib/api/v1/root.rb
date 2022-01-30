class API::V1::Root < Grape::API
  version  'v1'

  helpers do
    def raise_error(code, message)
      error_hash = {
        error_code: code,
        error_message: message
      }
      error!(error_hash)
    end
  end

  mount API::V1::Ping
  mount API::V1::Auth
  mount API::V1::NonAuth
end
