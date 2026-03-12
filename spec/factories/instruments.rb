FactoryBot.define do
  factory :instrument do
    sequence(:isin) { |n| "FR000012017#{n}" }
    sequence(:label) { |n| "Instrument #{n}" }
    instrument_type { :stock }
    price { 150.0 }
    sri { 6 }
  end
end