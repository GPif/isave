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

  def risk_level
    total_value = holdings.joins(:instrument).sum('holdings.amount * instruments.price')
    return 0 if total_value.zero?

    weighted_risk = holdings.joins(:instrument).sum('holdings.amount * instruments.price * instruments.sri')
    (weighted_risk.to_f / total_value).round(2)
  end

  def allocation_by_type
    allocation = holdings
      .joins(:instrument)
      .group('instruments.instrument_type')
      .sum('holdings.amount * instruments.price')

    total = allocation.values.sum
    return { stock: 0, bond: 0, euro_fund: 0 } if total.zero?

    result = { stock: 0, bond: 0, euro_fund: 0 }
    allocation.each do |type_str, value|
      type_key = type_str.to_sym
      result[type_key] = ((value.to_f / total) * 100).round(2)
    end
    result
  end

  def fee_amount
    total = amount
    return 0.0 if total.zero?

    fee = 0
    tiers = [5000, 7500, 10_000, Float::INFINITY]
    rates = [0.05, 0.03, 0.02, 0.008]

    curr_floor = 0
    tiers.each_with_index do |tier_limit, index|
      tier = [total - curr_floor, tier_limit - curr_floor].min
      fee += tier * rates[index]
      break if tier_limit >= total

      curr_floor = tier_limit
    end

    fee
  end

  def fee_percentage
    total = amount
    return 0.0 if total.zero?

    (fee_amount.to_f / total) * 100
  end
end
