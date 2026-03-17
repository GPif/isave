require 'rails_helper'

RSpec.describe PortfolioHistory, type: :model do
  let(:customer) { create(:customer) }

  describe "associations" do
    it { should belong_to(:portfolio) }
  end

  describe "performance" do
    let(:portfolio) { create(:portfolio, customer: customer) }

    it "returns performance at a given date" do
      # 1 week ago: (2500.0/1500.0 - 1)*100 = 66.66....
      create(:portfolio_history, portfolio: portfolio, amount: 1500.0, date: 2.weeks.ago)
      h = create(:portfolio_history, portfolio: portfolio, amount: 2500.0, date: 1.weeks.ago)
      create(:portfolio_history, portfolio: portfolio, amount: 10_000.0, date: Date.today)

      expect(h.performance.round(2)).to eq(66.67)
    end
  end
end
