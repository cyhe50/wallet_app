describe Gateway::InAppService do
  let(:user){ create(:user) }
  let!(:account){ create(:account, balance: 100, user: user) }
  let(:transfer_to){ create(:user) }

  subject{ described_class.new(user, transfer_to).transfer!(40, 'usd') }

  describe "#transfer" do
    context "successfully transfer money" do
      it do
        expect(subject).to be_truthy
        expect(account.reload.balance).to eq(60)
        expect(transfer_to.usd_account.balance).to eq(40)
      end
    end

    context "failed to transfer money" do
      it "insufficient money" do
        account.update(balance: 10)
        expect{ subject }.to raise_error(StandardError)
      end

      it "transfering failed" do
        allow(Transaction).to receive(:create!).and_raise(StandardError)
        expect{ subject }.to raise_error(StandardError)
      end
    end
  end
end
