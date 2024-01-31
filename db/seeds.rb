require 'csv'
csv_path = Rails.root.join('db', 'seeds', 'transactional-sample.csv')

Payment.transaction do
  CSV.foreach(csv_path, headers: true) do |row|
    payment = Payment.new(
      transaction_id: row["transaction_id"],
      merchant_id: row["merchant_id"],
      user_id: row["user_id"],
      card_number: row["card_number"],
      transaction_date: DateTime.parse(row["transaction_date"]),
      transaction_amount: row["transaction_amount"].to_d,
      device_id: row["device_id"],
      has_cbk: row["has_cbk"].downcase == "true"
    )

    payment.recommendation = RecommendationService.new(payment: payment, checker: :rule).recommend
    payment.save(validate: false)
  end
end

puts "Successfully imported #{Payment.count} payments from #{csv_path}"

puts "Trainning Payment Model"

PaymentModel.build

puts "Model trained"
