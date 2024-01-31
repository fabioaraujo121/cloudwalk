class RecommendationService
  def initialize(payment:, checker: :rule)
    @payment = payment
    @checker = checker # Possible: :rule || :ml || :worst
  end

  def recommend
    validate_recommendation ? :approve : :deny
  end

  private

  def validate_recommendation
    return false if any_chargeback?

    if @checker == :rule
      Recommendations::RuleBasedService.new(payment: @payment).valid?
    elsif @checker == :ml
      Recommendations::MlBasedService.new(payment: @payment).valid?
    elsif @checker == :worst
      rule_based = Recommendations::RuleBasedService.new(payment: @payment).valid?
      return false unless rule_based
      Recommendations::MlBasedService.new(payment: @payment).valid?
    end
  end

  def any_chargeback?
    Payment.exists?(user_id: @payment.user_id, has_cbk: true)
  end
end
