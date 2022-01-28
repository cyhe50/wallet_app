class API::V1::Ping < Grape::API
  get 'ping' do
    { data: 'pong' }
  end
end
