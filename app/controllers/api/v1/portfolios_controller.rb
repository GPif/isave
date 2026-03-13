module Api
  module V1
    class PortfoliosController < ApplicationController
      before_action :set_customer

      def index
        @portfolios = @customer.portfolios.includes(holdings: :instrument)
      end

      def show
        @portfolio = @customer.portfolios.includes(holdings: :instrument).find(params[:id])
      end

      private

      def set_customer
        @customer = Customer.find(params[:customer_id])
      end
    end
  end
end
