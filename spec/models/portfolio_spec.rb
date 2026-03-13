require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  let(:customer) { create(:customer) }

  describe "relations" do
    it { should have_many(:holdings) }
    it { should have_many(:instruments).through(:holdings) }
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
end
