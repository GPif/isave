json.label portfolio.label
json.performance portfolio.performance.to_f
json.total_fees portfolio.total_fees.to_f
json.historical_values portfolio.portfolio_histories, partial: 'api/v1/histories/portfolio_history', as: :history

if @date
  historical_at_date = portfolio.portfolio_histories.find_by(date: @date)
  if historical_at_date
    json.performance_at_date historical_at_date.performance.to_f
    json.fee_amount_at_date historical_at_date.fee_amount.to_f
    json.fee_percentage_at_date historical_at_date.fee_percentage.round(2).to_f
  else
    json.performance_at_date nil
    json.fee_amount_at_date nil
    json.fee_percentage_at_date nil
  end
end
