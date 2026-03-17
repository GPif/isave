class FeeService
  def self.calculate_fee(amount)
    return 0.0 if amount.zero?

    fee = 0
    tiers = [5000, 7500, 10_000, Float::INFINITY]
    rates = [0.05, 0.03, 0.02, 0.008]

    curr_floor = 0
    tiers.each_with_index do |tier_limit, index|
      tier = [amount - curr_floor, tier_limit - curr_floor].min
      fee += tier * rates[index]
      break if tier_limit >= amount

      curr_floor = tier_limit
    end
    fee
  end
end
