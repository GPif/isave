require 'rails_helper'

RSpec.describe ArbitrationService do
  let(:customer) { create(:customer) }
  let(:eligible_portfolio) { create(:portfolio, customer:, portfolio_type: :cto) }
  let(:ineligible_portfolio) { create(:portfolio, customer:, portfolio_type: :livret_a) }
  let(:instrument) { create(:instrument, price: 100.0) }

  describe "#deposit" do
    context "when portfolio is eligible (CTO)" do
      it "creates a new holding" do
        service = described_class.new(eligible_portfolio)

        expect {
          service.deposit(instrument.isin, 10)
        }.to change(Holding, :count).by(1)

        holding = eligible_portfolio.holdings.find_by(instrument:)
        expect(holding.amount).to eq(10)
      end

      it "increases existing holding amount" do
        create(:holding, portfolio: eligible_portfolio, instrument:, amount: 5)
        service = described_class.new(eligible_portfolio)

        expect {
          service.deposit(instrument.isin, 10)
        }.not_to change(Holding, :count)

        expect(eligible_portfolio.holdings.find_by(instrument:).amount).to eq(15)
      end
    end

    context "when portfolio is eligible (PEA)" do
      let(:pea_portfolio) { create(:portfolio, customer:, portfolio_type: :pea) }

      it "allows deposit" do
        service = described_class.new(pea_portfolio)

        expect {
          service.deposit(instrument.isin, 10)
        }.to change(Holding, :count).by(1)
      end
    end

    context "when portfolio is ineligible" do
      it "raises IneligiblePortfolioError" do
        service = described_class.new(ineligible_portfolio)

        expect {
          service.deposit(instrument.isin, 10)
        }.to raise_error(ArbitrationService::IneligiblePortfolioError)
      end
    end

    context "when instrument does not exist" do
      it "raises RecordNotFound" do
        service = described_class.new(eligible_portfolio)

        expect {
          service.deposit("INVALID", 10)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#withdraw" do
    context "when portfolio is eligible" do
      before { create(:holding, portfolio: eligible_portfolio, instrument:, amount: 20) }

      it "decreases holding amount" do
        service = described_class.new(eligible_portfolio)
        service.withdraw(instrument.isin, 10)

        expect(eligible_portfolio.holdings.find_by(instrument:).amount).to eq(10)
      end

      it "removes holding when amount becomes zero" do
        service = described_class.new(eligible_portfolio)
        service.withdraw(instrument.isin, 20)

        expect(eligible_portfolio.holdings.find_by(instrument:)).to be_nil
      end

      it "raises error when insufficient amount" do
        service = described_class.new(eligible_portfolio)

        expect {
          service.withdraw(instrument.isin, 30)
        }.to raise_error(ArbitrationService::InsufficientAmountError)
      end
    end

    context "when portfolio is ineligible" do
      it "raises IneligiblePortfolioError" do
        service = described_class.new(ineligible_portfolio)

        expect {
          service.withdraw(instrument.isin, 10)
        }.to raise_error(ArbitrationService::IneligiblePortfolioError)
      end
    end
  end

  describe "#transfer" do
    let(:source_instrument) { create(:instrument, isin: "FR101", price: 100.0) }
    let(:target_instrument) { create(:instrument, isin: "FR102", price: 100.0) }

    context "when portfolio is eligible" do
      before { create(:holding, portfolio: eligible_portfolio, instrument: source_instrument, amount: 20) }

      it "transfers amount from source instrument to target instrument" do
        service = described_class.new(eligible_portfolio)
        result = service.transfer(source_instrument.isin, target_instrument.isin, 10)

        expect(eligible_portfolio.holdings.find_by(instrument: source_instrument).amount).to eq(10)
        expect(eligible_portfolio.holdings.find_by(instrument: target_instrument).amount).to eq(10)
        expect(result[:amount]).to eq(10)
      end

      it "destroys source holding when fully transferred" do
        service = described_class.new(eligible_portfolio)
        service.transfer(source_instrument.isin, target_instrument.isin, 20)

        expect(eligible_portfolio.holdings.find_by(instrument: source_instrument)).to be_nil
        expect(eligible_portfolio.holdings.find_by(instrument: target_instrument).amount).to eq(20)
      end
    end

    context "when portfolio is ineligible" do
      it "raises IneligiblePortfolioError" do
        service = described_class.new(ineligible_portfolio)

        expect {
          service.transfer(source_instrument.isin, target_instrument.isin, 10)
        }.to raise_error(ArbitrationService::IneligiblePortfolioError)
      end
    end

    context "when source and target instruments are the same" do
      before { create(:holding, portfolio: eligible_portfolio, instrument: source_instrument, amount: 20) }

      it "raises InvalidTransferError" do
        service = described_class.new(eligible_portfolio)

        expect {
          service.transfer(source_instrument.isin, source_instrument.isin, 10)
        }.to raise_error(ArbitrationService::InvalidTransferError, "Source and target instruments must be different")
      end
    end

    context "when source instrument does not exist" do
      it "raises RecordNotFound" do
        service = described_class.new(eligible_portfolio)

        expect {
          service.transfer("INVALID", target_instrument.isin, 10)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
