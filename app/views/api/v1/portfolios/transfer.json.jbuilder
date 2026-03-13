json.partial! 'api/v1/portfolios/portfolio', portfolio: @portfolio
json.operation "transfer"
json.source_isin @source_isin
json.target_isin @target_isin
json.amount @amount