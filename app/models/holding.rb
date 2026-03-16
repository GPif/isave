class Holding < ApplicationRecord
  belongs_to :portfolio
  belongs_to :instrument

  validates :instrument_id, uniqueness: { scope: :portfolio_id }

  def share
    return 0 if portfolio.amount.zero?

    (amount * instrument.price) / portfolio.amount
  end

  def value
    amount * instrument.price
  end

  def risk_contribution
    share * instrument.sri
  end
end
