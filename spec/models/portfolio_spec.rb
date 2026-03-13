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
end
