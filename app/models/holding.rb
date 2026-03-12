class Holding < ApplicationRecord
  belongs_to :portfolio
  belongs_to :instrument
end
