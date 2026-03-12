require 'rails_helper'

RSpec.describe "Api::V1::Portfolios", type: :request do
  let(:customer) { create(:customer) }

  describe "GET /api/v1/customers/:customer_id/portfolios" do
    describe "GET /index" do
      context "when customer exists" do
        it "returns a successful response" do
          get api_v1_customer_portfolios_path(customer)
          expect(response).to have_http_status(:success)
        end

        it "returns contracts JSON" do
          get api_v1_customer_portfolios_path(customer)
          json = JSON.parse(response.body)
          expect(json).to have_key("contracts")
          expect(json["contracts"]).to be_an(Array)
        end

        it "returns empty contracts for customer without portfolios" do
          get api_v1_customer_portfolios_path(customer)
          json = JSON.parse(response.body)
          expect(json["contracts"]).to be_empty
        end
      end

      context "when customer does not exist" do
        it "returns 404 Not Found" do
          get api_v1_customer_portfolios_path(customer_id: 99999)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "GET /show" do
      let(:portfolio) { create(:portfolio, customer: customer) }

      context "when portfolio exists" do
        it "returns a successful response" do
          get api_v1_customer_portfolio_path(customer, portfolio)
          expect(response).to have_http_status(:success)
        end

        it "returns portfolio JSON with required keys" do
          get api_v1_customer_portfolio_path(customer, portfolio)
          json = JSON.parse(response.body)
          expect(json).to have_key("label")
          expect(json).to have_key("type")
          expect(json).to have_key("amount")
        end
      end

      context "when portfolio does not exist" do
        it "returns 404 Not Found" do
          get api_v1_customer_portfolio_path(customer, id: 99999)
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
