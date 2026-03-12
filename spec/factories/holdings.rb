FactoryBot.define do
  factory :holding do
    association :portfolio
    association :instrument
    amount { 1000.0 }
  end
end