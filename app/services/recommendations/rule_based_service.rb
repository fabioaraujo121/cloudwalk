class Recommendations::RuleBasedService
  MIN_INTERVAL_MINUTES          = 5
  MAX_TRANSACTIONS_IN_ROW       = 2
  TIMEFRAME_LIMIT_HOURS         = 24
  MAX_TRANSACTION_AMOUNT_IN_24H = 1_000.00

  def initialize(payment:)
    @payment  = payment
  end

  def valid?
    !invalid?
  end

  def invalid?
    above_timeframe_limit? || many_in_a_row?
  end

  private

  def many_in_a_row?
    target_datetime = @payment.transaction_date - MIN_INTERVAL_MINUTES.minutes
    recent_payments = payments.where("transaction_date >= ?", target_datetime).size

    recent_payments >= MAX_TRANSACTIONS_IN_ROW
  end

  def above_timeframe_limit?
    target_datetime = @payment.transaction_date - TIMEFRAME_LIMIT_HOURS.hours
    
    past_timeframe_amount = payments.where("transaction_date >= ?", target_datetime).sum(:transaction_amount)

    (past_timeframe_amount + @payment.transaction_amount) > MAX_TRANSACTION_AMOUNT_IN_24H
  end

  def payments
    @payments ||= begin
      start_datetime  = @payment.transaction_date - TIMEFRAME_LIMIT_HOURS.hours
      end_datetime    = @payment.transaction_date + MIN_INTERVAL_MINUTES.minutes
      target_interval = start_datetime..end_datetime

      Payment.where(user_id: @payment.user_id, transaction_date: target_interval)
    end
  end
end
