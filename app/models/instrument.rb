class Instrument < ApplicationRecord
  has_many :holdings
  has_many :portfolios, through: :holdings

  enum instrument_type: %i[stock bond euro_fund]
  validates :label, :instrument_type, :isin, :price, presence: true
  validates :isin, uniqueness: true
end
