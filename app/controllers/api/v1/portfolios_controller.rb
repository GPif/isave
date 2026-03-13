module Api
  module V1
    class PortfoliosController < ApplicationController
      before_action :set_customer
      before_action :set_portfolio, only: [:deposit, :withdraw, :transfer]

      def index
        @portfolios = @customer.portfolios.includes(holdings: :instrument)
      end

      def show
        @portfolio = @customer.portfolios.includes(holdings: :instrument).find(params[:id])
      end

      def deposit
        service = ArbitrationService.new(@portfolio)
        @amount = params[:amount].to_d
        service.deposit(params[:isin], @amount)
        @instrument = Instrument.find_by!(isin: params[:isin])
        @portfolio.reload

        render :deposit
      rescue ArbitrationService::IneligiblePortfolioError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end

      def withdraw
        service = ArbitrationService.new(@portfolio)
        @amount = params[:amount].to_d
        @instrument = Instrument.find_by!(isin: params[:isin])
        service.withdraw(params[:isin], @amount)
        @portfolio.reload

        render :withdraw
      rescue ArbitrationService::IneligiblePortfolioError,
             ArbitrationService::InsufficientAmountError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end

      def transfer
        service = ArbitrationService.new(@portfolio)
        @amount = params[:amount].to_d
        @source_isin = params[:source_isin]
        @target_isin = params[:target_isin]

        service.transfer(@source_isin, @target_isin, @amount)
        @portfolio.reload

        render :transfer
      rescue ArbitrationService::IneligiblePortfolioError,
             ArbitrationService::InsufficientAmountError,
             ArbitrationService::InvalidTransferError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      end

      private

      def set_customer
        @customer = Customer.find(params[:customer_id])
      end

      def set_portfolio
        @portfolio = @customer.portfolios.find(params[:id])
      end
    end
  end
end
