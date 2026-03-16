class Customer < ApplicationRecord
  has_many :portfolios, dependent: :destroy

  def overall_risk_level
    total_value = portfolios
                  .joins(holdings: :instrument)
                  .sum('holdings.amount * instruments.price')

    return 0 if total_value.zero?

    weighted_risk = portfolios
                    .joins(holdings: :instrument)
                    .sum('holdings.amount * instruments.price * instruments.sri')

    (weighted_risk / total_value).round(2)
  end

  def overall_allocation_by_type
    allocation = portfolios
                 .joins(holdings: :instrument)
                 .group('instruments.instrument_type')
                 .sum('holdings.amount * instruments.price')
                 .symbolize_keys

    total = allocation.values.sum
    result = { stock: 0, bond: 0, euro_fund: 0 }
    return result if total.zero?

    allocation.each do |type_str, value|
      result[type_str] = ((value.to_f / total) * 100).round(2)
    end
    result
  end

  def fee_amount
    portfolios.sum(&:fee_amount)
  end

  def fee_percentage
    total = portfolios.sum(&:amount)
    return 0 if total.zero?

    ((fee_amount / total) * 100)
  end
end
