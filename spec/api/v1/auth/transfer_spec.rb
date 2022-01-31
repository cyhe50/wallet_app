describe API::V1::Auth::Transfer, type: :request do
  let(:user){ create(:user) }
  let(:header_params){ {"User-Id" => user.id} }
  let(:user2){ create(:user) }
  let(:body_params){
    {
      "amount": 10,
      "currency": 'usd',
      "transfer_to_id": user2.id
    }
  }
  let(:bad_body_params){
    {
      "amount": 10,
      "currency": 'usd',
      "transfer_to_id": 2
    }
  }
  describe "POST api/v1/auth/transfer" do
    before do
      @double = double()
      allow(Gateway::InAppService).to receive(:new).and_return(@double)
    end
    context "post successfully" do
      it do
        allow(@double).to receive(:transfer!).and_return(true)
        api_request(:post, "v1", "auth/transfer", body_params, header_params)

        expect(response_body['status']).to eq('success')
      end
    end

    context "post failed" do
      it "transfer to user not found" do
        api_request(:post, "v1", "auth/transfer", bad_body_params, header_params)
        expect(response_body['error_code']).to eq(404)
      end

      it "data creating error" do
        allow(@double).to receive(:transfer!).and_raise(StandardError)
        api_request(:post, "v1", "auth/transfer", body_params, header_params)

        expect(response_body['error_code']).to eq(406)
      end
    end
  end
end
