class Portfolio < ApplicationRecord
  belongs_to :customer
  has_many :holdings, dependent: :destroy
  has_many :instruments, through: :holdings
  has_many :portfolio_histories, dependent: :destroy

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
    FeeService.calculate_fee(amount)
  end

  def total_fee
    portfolio_histories.sum { |history| FeeService.calculate_fee(history.amount) }
  end

  def fee_percentage
    total = amount
    return 0.0 if total.zero?

    (fee_amount.to_f / total) * 100
  end

  def initial_amount
    portfolio_histories.order(:date).first&.amount
  end

  def performance
    return 0.0 if portfolio_histories.count < 2

    (amount / initial_amount - 1) * 100
  end
end
