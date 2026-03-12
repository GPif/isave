module Api
  module V1
    class PortfoliosController < ApplicationController
      before_action :set_customer

      def index
        @portfolios = @customer.portfolios.includes(holdings: :instrument)

        # TODO: refactor contract
        render json: {
          contracts: @portfolios.map do |p|
            {
              label: p.label,
              type: p.portfolio_type,
              amount: p.amount,
              lines: p.holdings.map do |h|
                {
                  type: h.instrument.instrument_type,
                  isin: h.instrument.isin,
                  label: h.instrument.label,
                  price: h.instrument.price,
                  share: h.amount / p.amount,
                  amount: h.amount,
                  srri: h.instrument.sri
                }
              end.presence
            }
          end
        }
      end

      def show
        p = @customer.portfolios.includes(holdings: :instrument).find(params[:id])

        render json: {
          label: p.label,
          type: p.portfolio_type,
          amount: p.amount,
          lines: p.holdings.map do |h|
            {
              type: h.instrument.instrument_type,
              isin: h.instrument.isin,
              label: h.instrument.label,
              price: h.instrument.price,
              share: h.amount / p.amount,
              amount: h.amount,
              srri: h.instrument.sri
            }
          end.presence
        }
      end

      private

      def set_customer
        @customer = Customer.find(params[:customer_id])
      end
    end
  end
end
