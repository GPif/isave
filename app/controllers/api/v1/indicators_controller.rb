module Api
  module V1
    class IndicatorsController < ApplicationController
      def show
        @customer = Customer.includes(portfolios: { holdings: :instrument }).find(params[:customer_id])
      end
    end
  end
end
