class API::V1::Root < Grape::API
  version  'v1'
  format   :json

  formatter :json, API::V1::Formatter::Success

  helpers do
    def raise_error(code, message)
      error_hash = {
        error_code: code,
        error_message: message
      }
      error!(error_hash)
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error_code: 404, error_message: e.message }, 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error!({ error_code: 406, error_message: e.message }, 406)
  end
  mount API::V1::Ping
  mount API::V1::Auth
  mount API::V1::NonAuth
end
