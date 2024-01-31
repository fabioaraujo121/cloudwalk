class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :transaction_id
      t.string :merchant_id
      t.string :user_id
      t.string :card_number
      t.datetime :transaction_date
      t.decimal :transaction_amount
      t.string :device_id
      t.boolean :has_cbk
      t.string :recommendation

      t.timestamps
    end
  end
end
