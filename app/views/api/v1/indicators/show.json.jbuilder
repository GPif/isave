json.risk_level @customer.overall_risk_level
json.allocation_by_type @customer.overall_allocation_by_type

json.portfolios @customer.portfolios do |portfolio|
  json.id portfolio.id
  json.label portfolio.label
  json.risk_level portfolio.risk_level
  json.allocation_by_type portfolio.allocation_by_type
end
