describe API::V1::Auth::Deposit, type: :request do
  let(:user){ create(:user) }
  let(:body_params){
    {
      "creditcard": {
          "month": "12",
          "year": "2024",
          "number": "4242424242424242",
          "verification_value": "123"
      },
      "amount": 10,
      "currency": "usd"
    }
  }
  let(:header_params){ {"User-Id" => user.id} }

  describe "POST api/v1/auth/deposit" do
    before do
      @double = double()
      allow(Gateway::TrustCommerceService).to receive(:new).and_return(@double)
    end
    context "post successfully" do
      it do
        allow(@double).to receive(:purchase!).and_return(true)
        api_request(:post, "v1", "auth/deposit", body_params, header_params)

        expect(response_data).to eq('success')
      end
    end

    context "post failed" do
      it do
        allow(@double).to receive(:purchase!).and_raise(StandardError)
        api_request(:post, "v1", "auth/deposit", body_params, header_params)

        expect(response_body['error_code']).to eq(406)
      end
    end
  end
end
