module ResponseHelpers
  include Rack::Test::Methods

  def response_status
    last_response.status
  end

  def response_body
    last_response.body.present? ? JSON.parse(last_response.body) : Hash.new
  end

  def response_data
    response_body["data"]
  end

  def response_error_code
    response_body["error_code"]
  end
end

RSpec.configure do |config|
  config.include ResponseHelpers, type: :request
end
