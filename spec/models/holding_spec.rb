require 'rails_helper'

RSpec.describe Holding, type: :model do
  describe 'validations' do
    describe 'uniqueness of instrument within portfolio' do
      let(:customer) { create(:customer) }
      let(:portfolio) { create(:portfolio, customer: customer) }
      let(:instrument) { create(:instrument) }

      it 'prevents duplicate instrument in same portfolio' do
        create(:holding, portfolio: portfolio, instrument: instrument, amount: 1000)
        duplicate_holding = build(:holding, portfolio: portfolio, instrument: instrument, amount: 2000)

        expect(duplicate_holding).not_to be_valid
        expect(duplicate_holding.errors[:instrument_id]).to include("has already been taken")
      end

      it 'allows same instrument in different portfolios' do
        portfolio2 = create(:portfolio, customer: customer)
        create(:holding, portfolio: portfolio, instrument: instrument, amount: 1000)
        holding2 = build(:holding, portfolio: portfolio2, instrument: instrument, amount: 2000)

        expect(holding2).to be_valid
      end
    end
  end
end
