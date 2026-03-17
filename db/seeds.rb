# This file should ensur the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'json'

json = JSON.parse(File.read('data/level_1/portfolios.json'))

Customer.destroy_all

customer = Customer.create!(name: 'Client Principal', email: 'client@isave.fr')

json['contracts'].each do |contract|
  portfolio = customer.portfolios.create!(
    label: contract['label'],
    portfolio_type: Portfolio::PORTFOLIO_LOOKUP.invert[contract['type']],
  )

  next unless contract['lines']

  contract['lines'].each do |line|
    instrument = Instrument.find_or_create_by!(
      isin: line['isin']
    ) do |i|
      i.label = line['label']
      i.instrument_type = line['type']
      i.price = line['price']
      i.sri = line['srri']
    end

    portfolio.holdings.create!(
      instrument: instrument,
      amount: line['amount']
    )
  end
end

json = JSON.parse(File.read('data/level_4/historical_values.json'))

json.each do |lable, history|
  portfolio = Portfolio.find_by(label: lable)
  next unless portfolio

  history.each do |line|
    date = Date.strptime(line['date'], '%d-%m-%Y')
    date += 2000.years
    portfolio.portfolio_histories.create!(
      date: date,
      amount: line['amount']
    )
  end
end
