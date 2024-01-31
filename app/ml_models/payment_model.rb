class PaymentModel < Eps::Base
  def build
    payments = Payment.all

    # train
    data = payments.map { |v| features(v) }
    model = Eps::Model.new(data, target: :recommendation, split: :transaction_date)
    puts model.summary

    # save to file
    File.write(model_file, model.to_pmml)

    # ensure reloads from file
    @model = nil
  end

  def predict(payment)
    model.predict(features(payment))
  end

  private

  def features(payment)
    {
      transaction_id: payment.transaction_id,
      merchant_id: payment.merchant_id,
      user_id: payment.user_id,
      card_number: payment.card_number,
      transaction_date: payment.transaction_date,
      transaction_amount: payment.transaction_amount,
      device_id: payment.device_id,
      recommendation: payment.recommendation
    }
  end

  def model
    @model ||= Eps::Model.load_pmml(File.read(model_file))
  end

  def model_file
    Rails.root.join('lib', 'pmml_models', 'payment_model.pmml')
  end
end
