describe API::V1::Auth::Withdraw, type: :request do
  let(:user){ create(:user) }
  let(:body_params){
    {
      "amount": 10,
      "currency": "usd"
    }
  }
  let(:header_params){ {"User-Id" => user.id} }

  describe "POST api/v1/auth/withdraw" do
    before do
      @double = double()
      allow(Gateway::TrustCommerceService).to receive(:new).and_return(@double)
    end
    context "post successfully" do
      it do
        allow(@double).to receive(:refund!).and_return(true)
        api_request(:post, "v1", "auth/withdraw", body_params, header_params)

        expect(response_data).to eq('success')
      end
    end

    context "post failed" do
      it do
        allow(@double).to receive(:refund!).and_raise(StandardError)
        api_request(:post, "v1", "auth/withdraw", body_params, header_params)

        expect(response_body['error_code']).to eq(406)
      end
    end
  end
end
