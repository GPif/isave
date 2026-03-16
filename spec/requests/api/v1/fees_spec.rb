require 'rails_helper'

RSpec.describe "Api::V1::Fees", type: :request do
  let(:customer) { create(:customer) }

  describe "GET /api/v1/customers/:customer_id/portfolios/:id/fees" do
    let(:portfolio) { create(:portfolio, customer: customer) }

    context "when portfolio exists" do
      let!(:stock) { create(:instrument, price: 100.0) }
      let!(:holding) { create(:holding, portfolio: portfolio, instrument: stock, amount: 60) }

      it "returns a successful response" do
        get fees_api_v1_customer_portfolio_path(customer, portfolio)
        expect(response).to have_http_status(:success)
      end

      it "returns fee_amount" do
        get fees_api_v1_customer_portfolio_path(customer, portfolio)
        json = JSON.parse(response.body)
        expect(json).to have_key("fee_amount")
        # Portfolio amount = 60 * 100 = 6000
        # Fee: 5000 * 0.05 + 1000 * 0.03 = 250 + 30 = 280
        expect(json["fee_amount"]).to eq(280.0)
      end

      it "returns fee_percentage" do
        get fees_api_v1_customer_portfolio_path(customer, portfolio)
        json = JSON.parse(response.body)
        expect(json).to have_key("fee_percentage")
        # 280 / 6000 * 100 = 4.67%
        expect(json["fee_percentage"]).to eq(4.67)
      end
    end

    context "when portfolio has no holdings" do
      let(:empty_portfolio) { create(:portfolio, customer: customer) }

      it "returns zero fee_amount" do
        get fees_api_v1_customer_portfolio_path(customer, empty_portfolio)
        json = JSON.parse(response.body)
        expect(json["fee_amount"]).to eq(0.0)
      end

      it "returns zero fee_percentage" do
        get fees_api_v1_customer_portfolio_path(customer, empty_portfolio)
        json = JSON.parse(response.body)
        expect(json["fee_percentage"]).to eq(0.0)
      end
    end

    context "when portfolio does not exist" do
      it "returns 404 Not Found" do
        get fees_api_v1_customer_portfolio_path(customer, id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when customer does not exist" do
      it "returns 404 Not Found" do
        get fees_api_v1_customer_portfolio_path(customer_id: 99999, id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when portfolio belongs to another customer" do
      let(:other_customer) { create(:customer) }
      let(:other_portfolio) { create(:portfolio, customer: other_customer) }

      it "returns 404 Not Found" do
        get fees_api_v1_customer_portfolio_path(customer, other_portfolio)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /api/v1/customers/:customer_id/fees" do
    context "when customer exists" do
      let!(:portfolio) { create(:portfolio, customer: customer) }
      let!(:stock) { create(:instrument, price: 100.0) }
      let!(:holding) { create(:holding, portfolio: portfolio, instrument: stock, amount: 60) }

      it "returns a successful response" do
        get api_v1_customer_fees_path(customer)
        expect(response).to have_http_status(:success)
      end

      it "returns global fee_amount" do
        get api_v1_customer_fees_path(customer)
        json = JSON.parse(response.body)
        expect(json).to have_key("fee_amount")
        # Portfolio amount = 60 * 100 = 6000
        # Fee: 5000 * 0.05 + 1000 * 0.03 = 250 + 30 = 280
        expect(json["fee_amount"]).to eq(280.0)
      end

      it "returns global fee_percentage" do
        get api_v1_customer_fees_path(customer)
        json = JSON.parse(response.body)
        expect(json).to have_key("fee_percentage")
        # 280 / 6000 * 100 = 4.67%
        expect(json["fee_percentage"]).to eq(4.67)
      end
    end

    context "when customer has multiple portfolios" do
      let!(:portfolio1) { create(:portfolio, customer: customer) }
      let!(:portfolio2) { create(:portfolio, customer: customer) }
      let!(:stock) { create(:instrument, price: 100.0) }
      let!(:holding1) { create(:holding, portfolio: portfolio1, instrument: stock, amount: 30) }
      let!(:holding2) { create(:holding, portfolio: portfolio2, instrument: stock, amount: 80) }

      it "returns aggregated fees across all portfolios" do
        get api_v1_customer_fees_path(customer)
        json = JSON.parse(response.body)
        # Total: 3000 + 8000 = 11000
        # Portfolio 1 (3000): 5000 * 0.05 * (3000/5000) = 150 (tier 1 only)
        # Portfolio 2 (8000): 5000 * 0.05 + 2500 * 0.03 + 500 * 0.02 = 250 + 75 + 10 = 335
        # Total: 150 + 335 = 485
        expect(json["fee_amount"]).to eq(485.0)
      end
    end

    context "when customer has no portfolios" do
      let(:empty_customer) { create(:customer) }

      it "returns zero fees" do
        get api_v1_customer_fees_path(empty_customer)
        json = JSON.parse(response.body)
        expect(json["fee_amount"]).to eq(0.0)
        expect(json["fee_percentage"]).to eq(0.0)
      end
    end

    context "when customer does not exist" do
      it "returns 404 Not Found" do
        get api_v1_customer_fees_path(customer_id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
