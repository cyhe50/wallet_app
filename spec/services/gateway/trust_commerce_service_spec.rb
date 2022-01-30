describe Gateway::TrustCommerceService do
  let(:user){ create(:user) }
  let(:creditcard_params){
   {
      month: '9',
      year: '2024',
      number: '4242424242424242',
      verification_value:'424'
    }
  }
  let(:success_auth_response){
    OpenStruct.new({
      transaction_id: '039-0115095948',
      authorization: '039-0115095948|preauth',
      success?: true
    })
  }
  let(:success_cap_response){
    OpenStruct.new({
      transaction_id: '039-0115096481',
      authorization: '039-0115096481|postauth',
      success?: true
    })
  }
  let(:success_refund_response){
    OpenStruct.new({
      transaction_id: '039-0115098167',
      authorization: '039-0115098167|credit',
      success?: true
    })
  }
  let(:error_response){
    OpenStruct.new({
      error: "badformat",
      message: "A field was improperly formatted, such as non-digit characters in a number field",
      success?: false
    })
  }
  let(:service){ described_class.new(user, creditcard_params) }
  let(:response_double){ double() }

  describe "#purchase" do
    context "successfully deposit money in" do
      it do
        allow(Gateway::TrustCommerce::Base).to receive(:new).and_return(response_double)
        allow(response_double).to receive(:authorize).
          and_return(success_auth_response)
        allow(response_double).to receive(:capture).
          and_return(success_cap_response)

        service.purchase!(40, 'usd')

        expect(Transaction.count).to eq(1)
        transaction = Transaction.first
        expect(transaction.amount).to eq(40)
        expect(transaction.success?).to be_truthy

        expect(Account.count).to eq(1)
        expect(user.usd_account.balance).to eq(40)
      end
    end

    context "fail to deposit mondy" do
      it "authenticate pass but capture failed" do
        allow(Gateway::TrustCommerce::Base).to receive(:new).and_return(response_double)
        allow(response_double).to receive(:authorize).
          and_return(success_auth_response)
        allow(response_double).to receive(:capture).
          and_return(error_response)

        service.purchase!(40, 'usd')

        expect(Transaction.count).to eq(1)
        transaction = Transaction.first
        expect(transaction.failed?).to be_truthy

        expect(Account.count).to eq(1)
        expect(user.usd_account.balance).to eq(0)
      end

      it "authenticate failed" do
        allow(Gateway::TrustCommerce::Base).to receive(:new).and_return(response_double)
        allow(response_double).to receive(:authorize).
          and_return(error_response)

        expect{ service.purchase!(40, 'usd') }.to raise_error(StandardError)
      end
    end
  end

  describe "#refund" do
    let(:account){ create(:account, user: user) }
    let!(:transaction){ create(:transaction, :success, user: user, account: account) }

    context "successfully withdraw money back" do
      it do
        balance = account.reload.balance

        allow(Gateway::TrustCommerce::Base).to receive(:new).and_return(response_double)
        allow(response_double).to receive(:refund).
          and_return(success_refund_response)

        service.refund!(account, 40)

        expect(Transaction.count).to eq(2)
        trans = Transaction.last
        expect(trans.success?).to be_truthy
        expect(trans.amount).to eq(-40)

        expect(account.reload.balance).to eq(balance - 40)
      end
    end

    context "fail to withdraw mondy" do
      it "expect to raise error directly" do
        expect{ service.refund!(40, 'usd') }.to raise_error(StandardError)
      end
    end
  end
end
