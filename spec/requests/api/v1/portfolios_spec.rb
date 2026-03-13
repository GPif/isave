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

    describe "POST /deposit" do
      let(:eligible_portfolio) { create(:portfolio, customer:, portfolio_type: :cto) }
      let(:ineligible_portfolio) { create(:portfolio, customer:, portfolio_type: :livret_a) }
      let(:instrument) { create(:instrument, isin: "FR0000123456", price: 100.0) }

      context "when portfolio is eligible (CTO)" do
        it "creates a new holding" do
          expect {
            post deposit_api_v1_customer_portfolio_path(customer, eligible_portfolio),
                 params: { isin: instrument.isin, amount: 10 }
          }.to change(Holding, :count).by(1)

          expect(response).to have_http_status(:success)
        end

        it "returns portfolio JSON" do
          post deposit_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { isin: instrument.isin, amount: 10 }

          json = JSON.parse(response.body)
          expect(json).to have_key("label")
          expect(json["operation"]).to eq("deposit")
        end
      end

      context "when portfolio is eligible (PEA)" do
        let(:pea_portfolio) { create(:portfolio, customer:, portfolio_type: :pea) }

        it "allows deposit" do
          post deposit_api_v1_customer_portfolio_path(customer, pea_portfolio),
               params: { isin: instrument.isin, amount: 10 }

          expect(response).to have_http_status(:success)
        end
      end

      context "when portfolio is ineligible" do
        it "returns unprocessable entity" do
          post deposit_api_v1_customer_portfolio_path(customer, ineligible_portfolio),
               params: { isin: instrument.isin, amount: 10 }

          expect(response).to have_http_status(:unprocessable_entity)
          json = JSON.parse(response.body)
          expect(json["error"]).to include("not eligible")
        end
      end
    end

    describe "POST /withdraw" do
      let(:eligible_portfolio) { create(:portfolio, customer:, portfolio_type: :cto) }
      let(:ineligible_portfolio) { create(:portfolio, customer:, portfolio_type: :livret_a) }
      let(:instrument) { create(:instrument, isin: "FR0000123456", price: 100.0) }

      context "when portfolio is eligible" do
        before { create(:holding, portfolio: eligible_portfolio, instrument:, amount: 20) }

        it "decreases holding amount" do
          post withdraw_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { isin: instrument.isin, amount: 10 }

          expect(response).to have_http_status(:success)
          expect(eligible_portfolio.holdings.find_by(instrument:).amount).to eq(10)
        end

        it "removes holding when amount becomes zero" do
          post withdraw_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { isin: instrument.isin, amount: 20 }

          expect(eligible_portfolio.holdings.find_by(instrument:)).to be_nil
        end

        it "returns error when insufficient amount" do
          post withdraw_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { isin: instrument.isin, amount: 30 }

          expect(response).to have_http_status(:unprocessable_entity)
          json = JSON.parse(response.body)
          expect(json["error"]).to include("Insufficient")
        end
      end

      context "when portfolio is ineligible" do
        it "returns unprocessable entity" do
          post withdraw_api_v1_customer_portfolio_path(customer, ineligible_portfolio),
               params: { isin: instrument.isin, amount: 10 }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "POST /transfer" do
      let(:eligible_portfolio) { create(:portfolio, customer:, portfolio_type: :cto) }
      let(:source_instrument) { create(:instrument, isin: "FR0000111111", price: 100.0) }
      let(:target_instrument) { create(:instrument, isin: "FR0000222222", price: 100.0) }

      context "when portfolio is eligible" do
        before { create(:holding, portfolio: eligible_portfolio, instrument: source_instrument, amount: 20) }

        it "transfers amount from source to target instrument" do
          post transfer_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { source_isin: source_instrument.isin, target_isin: target_instrument.isin, amount: 10 }

          expect(response).to have_http_status(:success)
          expect(eligible_portfolio.holdings.find_by(instrument: source_instrument).amount).to eq(10)
          expect(eligible_portfolio.holdings.find_by(instrument: target_instrument).amount).to eq(10)
        end

        it "returns portfolio JSON with transfer details" do
          post transfer_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { source_isin: source_instrument.isin, target_isin: target_instrument.isin, amount: 10 }

          json = JSON.parse(response.body)
          expect(json["operation"]).to eq("transfer")
          expect(json["source_isin"]).to eq(source_instrument.isin)
          expect(json["target_isin"]).to eq(target_instrument.isin)
          expect(json["amount"]).to eq("10.0")
        end
      end

      context "when portfolio is ineligible" do
        let(:ineligible_portfolio) { create(:portfolio, customer:, portfolio_type: :livret_a) }

        it "returns unprocessable entity" do
          post transfer_api_v1_customer_portfolio_path(customer, ineligible_portfolio),
               params: { source_isin: source_instrument.isin, target_isin: target_instrument.isin, amount: 10 }

          expect(response).to have_http_status(:unprocessable_entity)
          json = JSON.parse(response.body)
          expect(json["error"]).to include("not eligible")
        end
      end

      context "when source and target instruments are the same" do
        before { create(:holding, portfolio: eligible_portfolio, instrument: source_instrument, amount: 20) }

        it "returns unprocessable entity" do
          post transfer_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { source_isin: source_instrument.isin, target_isin: source_instrument.isin, amount: 10 }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when insufficient amount" do
        before { create(:holding, portfolio: eligible_portfolio, instrument: source_instrument, amount: 5) }

        it "returns unprocessable entity" do
          post transfer_api_v1_customer_portfolio_path(customer, eligible_portfolio),
               params: { source_isin: source_instrument.isin, target_isin: target_instrument.isin, amount: 10 }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
