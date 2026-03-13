FactoryBot.define do
  factory :portfolio do
    association :customer
    sequence(:label) { |n| "Portfolio #{n}" }
    portfolio_type { :cto }
  end
end
