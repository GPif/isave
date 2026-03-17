require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  let(:customer) { create(:customer) }

  describe "relations" do
    it { should have_many(:holdings) }
    it { should have_many(:instruments).through(:holdings) }
    it { should have_many(:portfolio_histories) }
  end

  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:label) }
      it { should validate_presence_of(:portfolio_type) }
    end
  end

  describe "amount" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:instrument1) { create(:instrument) }
    let!(:holding1) { create(:holding, portfolio: portfolio, instrument: instrument1) }
    let!(:instrument2) { create(:instrument) }
    let!(:holding2) { create(:holding, portfolio: portfolio, instrument: instrument2) }

    it "should compute the total amount of the portfolio" do
      expect(portfolio.amount).to eq(holding1.amount * instrument1.price + holding2.amount * instrument2.price)
    end
  end

  describe "eligible?" do
    it "returns true for CTO portfolio" do
      portfolio = create(:portfolio, customer:, portfolio_type: :cto)
      expect(portfolio.eligible?).to be true
    end

    it "returns true for PEA portfolio" do
      portfolio = create(:portfolio, customer:, portfolio_type: :pea)
      expect(portfolio.eligible?).to be true
    end

    it "returns false for Livret A portfolio" do
      portfolio = create(:portfolio, customer:, portfolio_type: :livret_a)
      expect(portfolio.eligible?).to be false
    end

    it "returns false for Assurance Vie portfolio" do
      portfolio = create(:portfolio, customer:, portfolio_type: :assurance_vie)
      expect(portfolio.eligible?).to be false
    end

    it "returns false for Compte Dépôt portfolio" do
      portfolio = create(:portfolio, customer:, portfolio_type: :compte_depot)
      expect(portfolio.eligible?).to be false
    end
  end

  describe "risk_level" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:instrument1) { create(:instrument, price: 100.0, sri: 4) }
    let!(:instrument2) { create(:instrument, price: 200.0, sri: 6) }
    let!(:holding1) { create(:holding, portfolio: portfolio, instrument: instrument1, amount: 10) }
    let!(:holding2) { create(:holding, portfolio: portfolio, instrument: instrument2, amount: 5) }

    it "should compute the weighted risk level" do
      # holding1 value = 10 * 100 = 1000, risk contribution = 1000 * 4 = 4000
      # holding2 value = 5 * 200 = 1000, risk contribution = 1000 * 6 = 6000
      # total value = 2000
      # risk_level = (4000 + 6000) / 2000 = 5.0
      expect(portfolio.risk_level).to eq(5.0)
    end
  end

  describe "allocation_by_type" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:stock) { create(:instrument, price: 100.0, instrument_type: :stock) }
    let!(:bond) { create(:instrument, price: 200.0, instrument_type: :bond) }
    let!(:euro_fund) { create(:instrument, price: 50.0, instrument_type: :euro_fund) }
    let!(:holding1) { create(:holding, portfolio: portfolio, instrument: stock, amount: 10) }
    let!(:holding2) { create(:holding, portfolio: portfolio, instrument: bond, amount: 5) }
    let!(:holding3) { create(:holding, portfolio: portfolio, instrument: euro_fund, amount: 20) }

    it "should compute the allocation by type in percentage" do
      # stock value = 10 * 100 = 1000 (50%)
      # bond value = 5 * 200 = 1000 (50%)
      # euro_fund value = 20 * 50 = 1000 (0%)
      # total = 3000
      expect(portfolio.allocation_by_type).to eq({ stock: 33.33, bond: 33.33, euro_fund: 33.33 })
    end
  end

  describe "risk_level with empty portfolio" do
    let(:portfolio) { create(:portfolio, customer: customer) }

    it "returns 0 when portfolio has no holdings" do
      expect(portfolio.risk_level).to eq(0)
    end
  end

  describe "risk_level with single holding" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:instrument) { create(:instrument, price: 100.0, sri: 5) }
    let!(:holding) { create(:holding, portfolio: portfolio, instrument: instrument, amount: 10) }

    it "returns the SRI of that instrument" do
      # value = 10 * 100 = 1000
      # risk = 1000 * 5 / 1000 = 5.0
      expect(portfolio.risk_level).to eq(5.0)
    end
  end

  describe "risk_level with different values" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:low_risk) { create(:instrument, price: 100.0, sri: 2) }
    let!(:high_risk) { create(:instrument, price: 100.0, sri: 7) }
    let!(:holding1) { create(:holding, portfolio: portfolio, instrument: low_risk, amount: 80) }
    let!(:holding2) { create(:holding, portfolio: portfolio, instrument: high_risk, amount: 20) }

    it "returns weighted risk based on values" do
      # low_risk value = 80 * 100 = 8000, contribution = 8000 * 2 = 16000
      # high_risk value = 20 * 100 = 2000, contribution = 2000 * 7 = 14000
      # total value = 10000
      # risk_level = (16000 + 14000) / 10000 = 3.0
      expect(portfolio.risk_level).to eq(3.0)
    end
  end

  describe "allocation_by_type with empty portfolio" do
    let(:portfolio) { create(:portfolio, customer: customer) }

    it "returns zeros when portfolio has no holdings" do
      expect(portfolio.allocation_by_type).to eq({ stock: 0, bond: 0, euro_fund: 0 })
    end
  end

  describe "allocation_by_type with single type" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:stock) { create(:instrument, price: 50.0, instrument_type: :stock) }
    let!(:holding) { create(:holding, portfolio: portfolio, instrument: stock, amount: 10) }

    it "returns 100% for that type" do
      # value = 10 * 50 = 500
      expect(portfolio.allocation_by_type).to eq({ stock: 100.0, bond: 0, euro_fund: 0 })
    end
  end

  describe "allocation_by_type with two types" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:stock) { create(:instrument, price: 100.0, instrument_type: :stock) }
    let!(:bond) { create(:instrument, price: 100.0, instrument_type: :bond) }
    let!(:holding1) { create(:holding, portfolio: portfolio, instrument: stock, amount: 75) }
    let!(:holding2) { create(:holding, portfolio: portfolio, instrument: bond, amount: 25) }

    it "returns correct percentages" do
      # stock value = 75 * 100 = 7500 (75%)
      # bond value = 25 * 100 = 2500 (25%)
      # total = 10000
      expect(portfolio.allocation_by_type).to eq({ stock: 75.0, bond: 25.0, euro_fund: 0 })
    end
  end

  describe "fee_amount" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:stock) { create(:instrument, price: 100.0, instrument_type: :stock) }
    let!(:bond) { create(:instrument, price: 100.0, instrument_type: :bond) }
    let!(:holding1) { create(:holding, portfolio: portfolio, instrument: stock, amount: 75) }
    let!(:holding2) { create(:holding, portfolio: portfolio, instrument: bond, amount: 25) }

    it "returns correct fee amount" do
      # stock value = 75 * 100 = 7500 (75%)
      # bond value = 25 * 100 = 2500 (25%)
      # total = 10000
      # fee = 5000 * 0.05 + 2500 * 0.03 + 2500 * 0.02 = 375
      expect(portfolio.fee_amount).to eq(375.0)
    end

    it "returns correct fee percentage" do
      # total = 10000
      # fee = 375
      # percentage = 3.75%
      expect(portfolio.fee_percentage).to eq(3.75)
    end
  end

  describe "initial_amount" do
    let(:portfolio) { create(:portfolio, customer: customer) }

    it "returns the initial amount from the first portfolio history" do
      create(:portfolio_history, portfolio: portfolio, amount: 10000.0, date: 1.weeks.ago)
      create(:portfolio_history, portfolio: portfolio, amount: 5000.0, date: Date.today)
      expect(portfolio.initial_amount).to eq(10000.0)
    end

    it "returns nil if there are no portfolio histories" do
      expect(portfolio.initial_amount).to be_nil
    end
  end

  describe "performance" do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let!(:instrument) { create(:instrument, price: 100.0) }
    let!(:holding) { create(:holding, portfolio: portfolio, instrument: instrument, amount: 100) }

    it "returns 0.0 if there are less than 2 portfolio histories" do
      expect(portfolio.performance).to eq(0.0)
    end

    it "returns the correct performance percentage" do
      create(:portfolio_history, portfolio: portfolio, amount: 2500.0, date: 1.weeks.ago)
      create(:portfolio_history, portfolio: portfolio, amount: 10_000.0, date: Date.today)
      expect(portfolio.performance).to eq(300.0)
    end
  end
end
