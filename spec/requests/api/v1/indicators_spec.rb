require 'rails_helper'

RSpec.describe "Api::V1::Indicators", type: :request do
  let(:customer) { create(:customer) }

  describe "GET /api/v1/customers/:customer_id/indicators" do
    let(:portfolio) { create(:portfolio, customer: customer) }

    context "when customer exists" do
      let!(:stock) { create(:instrument, price: 100.0, sri: 4, instrument_type: :stock) }
      let!(:bond) { create(:instrument, price: 200.0, sri: 6, instrument_type: :bond) }
      let!(:holding1) { create(:holding, portfolio: portfolio, instrument: stock, amount: 10) }
      let!(:holding2) { create(:holding, portfolio: portfolio, instrument: bond, amount: 5) }

      it "returns a successful response" do
        get api_v1_customer_indicators_path(customer)
        expect(response).to have_http_status(:success)
      end

      it "returns risk_level" do
        get api_v1_customer_indicators_path(customer)
        json = JSON.parse(response.body)
        expect(json).to have_key("risk_level")
        expect(json["risk_level"]).to eq(5.0)
      end

      it "returns allocation_by_type" do
        get api_v1_customer_indicators_path(customer)
        json = JSON.parse(response.body)
        expect(json).to have_key("allocation_by_type")
        expect(json["allocation_by_type"]).to have_key("stock")
        expect(json["allocation_by_type"]).to have_key("bond")
        expect(json["allocation_by_type"]).to have_key("euro_fund")
      end

      it "returns portfolios with risk_level and allocation_by_type" do
        get api_v1_customer_indicators_path(customer)
        json = JSON.parse(response.body)
        expect(json).to have_key("portfolios")
        expect(json["portfolios"].length).to eq(1)

        portfolio = json["portfolios"].first
        expect(portfolio).to have_key("id")
        expect(portfolio).to have_key("label")
        expect(portfolio).to have_key("risk_level")
        expect(portfolio).to have_key("allocation_by_type")
        expect(portfolio["risk_level"]).to eq(5.0)
      end
    end

    context "when customer has no portfolios" do
      let(:empty_customer) { create(:customer) }

      it "returns zero risk_level" do
        get api_v1_customer_indicators_path(empty_customer)
        json = JSON.parse(response.body)
        expect(json["risk_level"]).to eq(0)
      end

      it "returns zero allocation by type" do
        get api_v1_customer_indicators_path(empty_customer)
        json = JSON.parse(response.body)
        expect(json["allocation_by_type"]).to eq({ "stock" => 0, "bond" => 0, "euro_fund" => 0 })
      end
    end

    context "when customer does not exist" do
      it "returns 404 Not Found" do
        get api_v1_customer_indicators_path(customer_id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
