class Customer < ApplicationRecord
  has_many :portfolios, dependent: :destroy
end
