class Holding < ApplicationRecord
  belongs_to :portfolio
  belongs_to :instrument

  validates :instrument_id, uniqueness: { scope: :portfolio_id }

  def share
    portfolio.amount / (amount * instrument.price)
  end
end
