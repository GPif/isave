require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "relations" do
    it { should have_many(:portfolios) }
  end

  describe "overall_risk_level" do
    let(:customer) { create(:customer) }
    let(:portfolio1) { create(:portfolio, customer: customer) }
    let(:portfolio2) { create(:portfolio, customer: customer) }

    let!(:instrument1) { create(:instrument, price: 100.0, sri: 4) }
    let!(:instrument2) { create(:instrument, price: 200.0, sri: 6) }
    let!(:holding1) { create(:holding, portfolio: portfolio1, instrument: instrument1, amount: 10) }
    let!(:holding2) { create(:holding, portfolio: portfolio2, instrument: instrument2, amount: 5) }

    it "should compute the weighted risk level across all portfolios" do
      # portfolio1 value = 10 * 100 = 1000, risk = 1000 * 4 = 4000
      # portfolio2 value = 5 * 200 = 1000, risk = 1000 * 6 = 6000
      # total value = 2000
      # overall_risk_level = (4000 + 6000) / 2000 = 5.0
      expect(customer.overall_risk_level).to eq(5.0)
    end

    it "returns 0 when customer has no portfolios" do
      empty_customer = create(:customer)
      expect(empty_customer.overall_risk_level).to eq(0)
    end

    it "returns 0 when all portfolios are empty" do
      portfolio3 = create(:portfolio, customer: customer)
      expect(customer.overall_risk_level).to eq(5.0)
    end
  end

  describe "overall_allocation_by_type" do
    let(:customer) { create(:customer) }
    let(:portfolio1) { create(:portfolio, customer: customer) }
    let(:portfolio2) { create(:portfolio, customer: customer) }

    let!(:stock) { create(:instrument, price: 100.0, instrument_type: :stock) }
    let!(:bond) { create(:instrument, price: 200.0, instrument_type: :bond) }
    let!(:euro_fund) { create(:instrument, price: 50.0, instrument_type: :euro_fund) }

    let!(:holding1) { create(:holding, portfolio: portfolio1, instrument: stock, amount: 10) }
    let!(:holding2) { create(:holding, portfolio: portfolio2, instrument: bond, amount: 5) }
    let!(:holding3) { create(:holding, portfolio: portfolio1, instrument: euro_fund, amount: 20) }

    it "should compute the allocation by type across all portfolios" do
      # stock value = 10 * 100 = 1000
      # bond value = 5 * 200 = 1000
      # euro_fund value = 20 * 50 = 1000
      # total = 3000
      expect(customer.overall_allocation_by_type).to eq({ stock: 33.33, bond: 33.33, euro_fund: 33.33 })
    end

    it "returns zero allocation when customer has no portfolios" do
      empty_customer = create(:customer)
      expect(empty_customer.overall_allocation_by_type).to eq({ stock: 0, bond: 0, euro_fund: 0 })
    end
  end

  describe "fee_amount" do
    let(:customer) { create(:customer) }
    let(:portfolio1) { create(:portfolio, customer: customer) }
    let(:portfolio2) { create(:portfolio, customer: customer) }
    let!(:stock) { create(:instrument, price: 100.0, instrument_type: :stock) }
    let!(:bond) { create(:instrument, price: 100.0, instrument_type: :bond) }
    let!(:euro_fund) { create(:instrument, price: 50.0, instrument_type: :euro_fund) }
    let!(:holding1) { create(:holding, portfolio: portfolio1, instrument: stock, amount: 75) }
    let!(:holding2) { create(:holding, portfolio: portfolio1, instrument: bond, amount: 25) }
    let!(:holding3) { create(:holding, portfolio: portfolio2, instrument: euro_fund, amount: 20) }

    it "returns correct fee amount" do
      # stock value = 75 * 100 = 7500 (75%)
      # bond value = 25 * 100 = 2500 (25%)
      # euro_fund value = 20 * 50 = 1000 (20%)
      # total = 11000
      # fee portfolio 1 = 5000 * 0.05 + 2500 * 0.03 + 2500 * 0.02 = 375
      # fee portfolio 2 = 1000 * 0.05 = 50
      # fee total = 425
      expect(customer.fee_amount).to eq(425)
    end

    it "returns correct fee amount percent" do
      expect(customer.fee_percentage.round(2)).to eq(3.86)
    end
  end
end
