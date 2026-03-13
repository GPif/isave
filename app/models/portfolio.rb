class Portfolio < ApplicationRecord
  belongs_to :customer
  has_many :holdings, dependent: :destroy
  has_many :instruments, through: :holdings

  enum :portfolio_type, %i[cto pea assurance_vie livret_a compte_depot]
  validates :label, :portfolio_type, presence: true

  PORTFOLIO_LOOKUP = {
    cto: 'CTO',
    pea: 'PEA',
    assurance_vie: 'Assurance Vie',
    livret_a: 'Livret A',
    compte_depot: 'Compte dépôt'
  }

  def amount
    holdings.includes(:instrument).sum('holdings.amount * instruments.price')
  end

  def eligible?
    cto? || pea?
  end
end
