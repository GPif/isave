require 'rails_helper'

RSpec.describe Instrument, type: :model do
  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:isin) }
      it { should validate_presence_of(:label) }
      it { should validate_presence_of(:price) }
      it { should validate_presence_of(:instrument_type) }
    end
  end
end
