require 'rails_helper'

RSpec.describe FeeService do
  describe 'calculate_fee' do
    it 'calculates the fee correctly' do
      # 12_000 : 5000 * 0.05 + 2500 * 0.03 + 2500 * 0.02 + 2000 * 0.008 = 391
      expect(FeeService.calculate_fee(12_000)).to eq(391)
      # 12_000 : 5000 * 0.05
      expect(FeeService.calculate_fee(5000)).to eq(250)
    end
  end
end
