module Api
  module V1
    class HistoriesController < ApplicationController
      def index
        @customer = Customer.includes(portfolios: [:portfolio_histories, { holdings: :instrument }]).find(params[:customer_id])
        @date = params[:date]&.to_date
      end

      def show
        @customer = Customer.find(params[:customer_id])
        @portfolio = @customer.portfolios.includes(:portfolio_histories, holdings: :instrument).find(params[:id])
        @date = params[:date]&.to_date
      end
    end
  end
end
