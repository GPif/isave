require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  describe "validations" do
    describe "presence" do
      it { should validate_presence_of(:label) }
      it { should validate_presence_of(:portfolio_type) }
    end
  end
end
