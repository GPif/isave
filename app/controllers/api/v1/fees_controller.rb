module Api
  module V1
    class FeesController < ApplicationController
      before_action :set_customer
      before_action :set_portfolio, only: [:show]

      def show
        render 'portfolio_fees' if params[:id]
      end

      private

      def set_customer
        @customer = Customer.find(params[:customer_id])
      end

      def set_portfolio
        @portfolio = @customer.portfolios.find(params[:id]) if params[:id]
      end
    end
  end
end
