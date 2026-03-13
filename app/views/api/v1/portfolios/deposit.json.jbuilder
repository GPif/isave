json.partial! 'api/v1/portfolios/portfolio', portfolio: @portfolio
json.operation "deposit"
json.isin @instrument.isin
json.amount @amount