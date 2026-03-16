require 'rails_helper'

RSpec.describe Holding, type: :model do
  let(:customer) { create(:customer) }

  describe 'validations' do
    describe 'uniqueness of instrument within portfolio' do
      let(:portfolio) { create(:portfolio, customer: customer) }
      let(:instrument) { create(:instrument) }

      it 'prevents duplicate instrument in same portfolio' do
        create(:holding, portfolio: portfolio, instrument: instrument)
        duplicate_holding = build(:holding, portfolio: portfolio, instrument: instrument)

        expect(duplicate_holding).not_to be_valid
        expect(duplicate_holding.errors[:instrument_id]).to include("has already been taken")
      end

      it 'allows same instrument in different portfolios' do
        portfolio2 = create(:portfolio, customer: customer)
        create(:holding, portfolio: portfolio, instrument: instrument)
        holding2 = build(:holding, portfolio: portfolio2, instrument: instrument)

        expect(holding2).to be_valid
      end
    end
  end

  describe 'share' do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let(:instrument) { create(:instrument) }

    subject { create(:holding, portfolio: portfolio, instrument: instrument, amount: 10) }

    it 'should compute the correct share' do
      expect(subject.share).to eq(1.0)
    end
  end

  describe 'value' do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let(:instrument) { create(:instrument, price: 100.0) }

    subject { create(:holding, portfolio: portfolio, instrument: instrument, amount: 5) }

    it 'should compute the correct value' do
      expect(subject.value).to eq(500.0)
    end
  end

  describe 'risk_contribution' do
    let(:portfolio) { create(:portfolio, customer: customer) }
    let(:instrument) { create(:instrument, price: 100.0, sri: 6) }

    subject { create(:holding, portfolio: portfolio, instrument: instrument, amount: 10) }

    it 'should compute the correct risk contribution' do
      expect(subject.risk_contribution).to eq(6.0)
    end
  end
end
