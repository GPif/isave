class PortfolioHistory < ApplicationRecord
  belongs_to :portfolio

  def performance
    (amount / portfolio.initial_amount - 1) * 100
  end

  def fee_amount
    FeeService.calculate_fee(amount)
  end

  def fee_percentage
    fee_amount / amount * 100
  end
end
