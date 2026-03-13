class ArbitrationService
  class IneligiblePortfolioError < StandardError; end
  class InsufficientAmountError < StandardError; end
  class InvalidTransferError < StandardError; end

  def initialize(portfolio)
    @portfolio = portfolio
  end

  def deposit(isin, amount)
    ensure_eligible!
    instrument = find_instrument!(isin)

    holding = @portfolio.holdings.find_or_initialize_by(instrument:)
    holding.amount ||= 0
    holding.amount += amount
    holding.save!
    holding
  end

  def withdraw(isin, amount)
    ensure_eligible!
    instrument = find_instrument!(isin)

    holding = @portfolio.holdings.find_by!(instrument:)
    raise InsufficientAmountError, "Insufficient amount in portfolio" if holding.amount < amount

    holding.amount -= amount
    if holding.amount.zero?
      holding.destroy!
      nil
    else
      holding.save!
      holding
    end
  end

  def transfer(source_isin, target_isin, amount)
    ensure_eligible!
    raise InvalidTransferError, "Source and target instruments must be different" if source_isin == target_isin

    withdraw(source_isin, amount)

    deposit(target_isin, amount)

    {
      portfolio: @portfolio,
      source_instrument: find_instrument!(source_isin),
      target_instrument: find_instrument!(target_isin),
      amount:
    }
  end

  private

  def ensure_eligible!
    raise IneligiblePortfolioError, "Portfolio is not eligible for this operation" unless @portfolio.eligible?
  end

  def find_instrument!(isin)
    instrument = Instrument.find_by(isin:)
    raise ActiveRecord::RecordNotFound, "Instrument not found" unless instrument
    instrument
  end

  def same_customer?(other_portfolio)
    @portfolio.customer_id == other_portfolio.customer_id
  end
end
