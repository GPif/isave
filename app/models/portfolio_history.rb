class PortfolioHistory < ApplicationRecord
  belongs_to :portfolio

  def performance
    (amount / portfolio.initial_amount - 1) * 100
  end
end
