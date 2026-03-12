class Instrument < ApplicationRecord
  has_many :holdings
  has_many :portfolios, through: :holdings
end
