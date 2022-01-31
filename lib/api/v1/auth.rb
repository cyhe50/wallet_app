class API::V1::Auth < Grape::API

  before do
    # TODO: implement authentication
    @current_user = User.find_by(id: headers['User-Id'])
    raise_error(403, 'user not found') if @current_user.nil?
  end

  helpers do
    def current_user
      @current_user
    end
  end

  resource :auth do
    mount API::V1::Auth::Deposit
    mount API::V1::Auth::Withdraw
    mount API::V1::Auth::Transfer
    mount API::V1::Auth::Accounts
  end
end
