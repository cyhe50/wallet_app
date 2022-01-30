module RequestHelpers
  def api_request(type, version, path, params = {}, headers = {})
    full_path = "api/#{version}/#{path}"
    session = Rack::Test::Session.new(rack_mock_session)
    headers.merge(default_headers).each do |k,v|
      session.header k, v
    end
    if type == :get
      session.send(type, full_path, params)
    else
      session.send(type, full_path, params.to_json)
    end
  end

  private

  def default_headers
    { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
