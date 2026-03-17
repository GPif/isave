class PortfolioHistory < ApplicationRecord
  belongs_to :portfolio

  scope :last_per_month_before, ->(cutoff_date = nil) {
    if cutoff_date.present?
      where("date <= ?", cutoff_date)
        .where(<<~SQL, cutoff_date)
          date = (
            SELECT MAX(ph2.date)
            FROM portfolio_histories ph2
            WHERE strftime('%Y-%m', ph2.date) = strftime('%Y-%m', portfolio_histories.date)
              AND ph2.portfolio_id = portfolio_histories.portfolio_id
              AND ph2.date <= ?
          )
        SQL
        .order(date: :desc)
    else
      where(<<~SQL)
        date = (
          SELECT MAX(ph2.date)
          FROM portfolio_histories ph2
          WHERE strftime('%Y-%m', ph2.date) = strftime('%Y-%m', portfolio_histories.date)
            AND ph2.portfolio_id = portfolio_histories.portfolio_id
        )
      SQL
      .order(date: :desc)
    end
  }

  def performance
    (amount / portfolio.initial_amount - 1) * 100
  end

  def fee_amount
    FeeService.calculate_fee(amount)
  end

  def fee_percentage
    fee_amount / amount * 100
  end
end
