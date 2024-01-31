class Recommendations::MlBasedService
  def initialize(payment:)
    @payment  = payment
  end

  def valid?
    PaymentModel.predict(@payment) == 'approve'
  end

  def invalid?
    !valid?
  end
end
