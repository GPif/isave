require 'rails_helper'

RSpec.describe "Api::V1::Histories", type: :request do
  let(:customer) { create(:customer) }

  describe "GET /api/v1/customers/:customer_id/histories" do
    let!(:portfolio1) { create(:portfolio, customer: customer, label: "Portefeuille d'actions", portfolio_type: :cto) }
    let!(:portfolio2) { create(:portfolio, customer: customer, label: "Compte courant", portfolio_type: :compte_depot) }

    let!(:stock) { create(:instrument, price: 100.0) }
    let!(:holding1) { create(:holding, portfolio: portfolio1, instrument: stock, amount: 150) }
    let!(:holding2) { create(:holding, portfolio: portfolio2, instrument: stock, amount: 180) }

    # Create portfolio histories to simulate historical data
    let!(:history1_old) { create(:portfolio_history, portfolio: portfolio1, date: "2022-01-01", amount: 400) }
    let!(:history1_mid) { create(:portfolio_history, portfolio: portfolio1, date: "2022-06-01", amount: 450) }
    let!(:history1_new) { create(:portfolio_history, portfolio: portfolio1, date: "2023-12-30", amount: 15000) }
    let!(:history2_old) { create(:portfolio_history, portfolio: portfolio2, date: "2022-01-01", amount: 18000) }
    let!(:history2_new) { create(:portfolio_history, portfolio: portfolio2, date: "2023-12-30", amount: 18000) }


    context "when customer exists" do
      it "returns a successful response" do
        get api_v1_customer_histories_path(customer)
        expect(response).to have_http_status(:success)
      end

      it "returns portfolios with historical valuations" do
        get api_v1_customer_histories_path(customer)
        json = JSON.parse(response.body)

        expect(json).to have_key("portfolios")
        expect(json["portfolios"]).to be_an(Array)

        portfolio_names = json["portfolios"].map { |p| p["label"] }
        expect(portfolio_names).to include("Portefeuille d'actions")
        expect(portfolio_names).to include("Compte courant")
      end

      it "returns historical values for each portfolio" do
        get api_v1_customer_histories_path(customer)
        json = JSON.parse(response.body)

        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }
        expect(portfolio).to have_key("historical_values")
        expect(portfolio["historical_values"]).to be_an(Array)
        expect(portfolio["historical_values"].first).to have_key("date")
        expect(portfolio["historical_values"].first).to have_key("amount")
      end

      it "returns performance for each portfolio" do
        get api_v1_customer_histories_path(customer)
        json = JSON.parse(response.body)

        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }
        expect(portfolio).to have_key("performance")
        # Return = (15000/400 - 1) * 100 = 3650%
        expect(portfolio["performance"]).to eq(3650.0)
      end

      it "returns performance at a specific date" do
        get api_v1_customer_histories_path(customer)
        json = JSON.parse(response.body)
        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }

        portfolio_history = portfolio["historical_values"].find { |p| p["date"] == "2022-06-01"}
        expect(portfolio_history).to have_key("performance")
        # From historical_values.json: date "22-01-22" amount = 463
        # Return = (450/400 - 1) * 100 = 12.5%
        expect(portfolio_history["performance"]).to eq(12.5)
      end

      it "returns fees at a specific date" do
        get api_v1_customer_histories_path(customer, date: "2022-06-01")
        json = JSON.parse(response.body)

        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }
        expect(portfolio).to have_key("total_fees")
      end

      it "returns total fees since portfolio was added" do
        get api_v1_customer_histories_path(customer)
        json = JSON.parse(response.body)

        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }
        expect(portfolio).to have_key("total_fees")
        expect(portfolio["total_fees"]).to be_a(Numeric)
        expect(portfolio["total_fees"]).to be > 0
      end
    end

    context "when customer has no portfolios" do
      let(:empty_customer) { create(:customer) }

      it "returns empty portfolios array" do
        get api_v1_customer_histories_path(empty_customer)
        json = JSON.parse(response.body)

        expect(json["portfolios"]).to eq([])
      end
    end

    context "when customer does not exist" do
      it "returns 404 Not Found" do
        get api_v1_customer_histories_path(customer_id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "without date parameter" do
      it "returns current state without return_at_date" do
        get api_v1_customer_histories_path(customer)
        json = JSON.parse(response.body)

        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }
        expect(portfolio).not_to have_key("return_at_date")
      end
    end

    context "with invalid date parameter" do
      it "returns nil for return_at_date when date not found" do
        get api_v1_customer_histories_path(customer, date: "2030-01-01")
        json = JSON.parse(response.body)

        portfolio = json["portfolios"].find { |p| p["label"] == "Portefeuille d'actions" }
        expect(portfolio["return_at_date"]).to be_nil
      end
    end
  end

  describe "GET /api/v1/customers/:customer_id/histories/:id" do
    let!(:portfolio) { create(:portfolio, customer: customer, label: "PEA - Portefeuille Équilibré", portfolio_type: :pea) }

    context "when portfolio exists" do
      it "returns historical data for a specific portfolio" do
        get history_api_v1_customer_portfolio_path(customer, portfolio)
        expect(response).to have_http_status(:success)
      end

      it "returns portfolio details with historical values" do
        get history_api_v1_customer_portfolio_path(customer, portfolio)
        json = JSON.parse(response.body)

        expect(json["label"]).to eq("PEA - Portefeuille Équilibré")
        expect(json).to have_key("historical_values")
        expect(json).to have_key("performance")
      end
    end

    context "when portfolio does not exist" do
      it "returns 404 Not Found" do
        get history_api_v1_customer_portfolio_path(customer, id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when date parameter is provided" do
      let!(:stock) { create(:instrument, price: 100.0) }
      let!(:holding) { create(:holding, portfolio: portfolio, instrument: stock, amount: 150) }

      # Create portfolio histories to simulate historical data
      let!(:history_old) { create(:portfolio_history, portfolio: portfolio, date: "2022-01-01", amount: 400) }
      let!(:history_mid) { create(:portfolio_history, portfolio: portfolio, date: "2022-06-01", amount: 450) }
      let!(:history_new) { create(:portfolio_history, portfolio: portfolio, date: "2023-12-30", amount: 15000) }

      it "returns historical data for a specific date" do
        get history_api_v1_customer_portfolio_path(customer, portfolio, date: "2022-06-01")
        json = JSON.parse(response.body)

        expect(json["label"]).to eq("PEA - Portefeuille Équilibré")
        expect(json).to have_key("historical_values")
        expect(json).to have_key("performance_at_date")
        expect(json["performance_at_date"]).to eq(12.5)
        expect(json).to have_key("fee_amount_at_date")
        expect(json["fee_amount_at_date"]).to eq(22.5)
        expect(json).to have_key("fee_percentage_at_date")
        expect(json["fee_percentage_at_date"]).to eq(5.0)
      end
    end
  end
end
