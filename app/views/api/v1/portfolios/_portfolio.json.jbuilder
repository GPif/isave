json.label portfolio.label
json.type portfolio.portfolio_type
json.amount portfolio.amount
json.lines portfolio.holdings.map do |h|
  json.type h.instrument.instrument_type
  json.isin h.instrument.isin
  json.label h.instrument.label
  json.price h.instrument.price
  json.share h.amount / portfolio.amount
  json.amount h.amount
  json.srri h.instrument.sri
end.presence
