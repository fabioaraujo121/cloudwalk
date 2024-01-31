class Payment < ApplicationRecord
  validates :transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :device_id, presence: true
  validates :transaction_amount, numericality: { greater_than: 0 }
end
