require 'rails_helper'

RSpec.describe '/api/v1/payments', type: :request do
  let(:valid_attributes) do
    {
      transaction_id: '123',
      merchant_id: '321',
      user_id: '123321',
      card_number: '434505******9116',
      transaction_date: '2019-12-01T23:16:32.812632',
      transaction_amount: 374.56,
      device_id: '123321123'
    }
  end

  let(:json_response) { response.parsed_body }

  let(:headers) { { HTTP_AUTHORIZATION: 'Token secret' } }

  describe 'POST /create' do
    context 'Happy Path ☀️' do
      context 'with valid payments' do
        it 'creates a new Payment' do
          expect do
            post api_v1_payments_path, params: { payment: valid_attributes }, headers: headers
          end.to change(Payment, :count).by(1)

          expect(json_response['transaction_id']).to eq valid_attributes[:transaction_id]
          expect(json_response['recommendation']).to eq 'approve'
          expect(response.status).to eq 201
        end
      end
    end

    context 'Sad Path ⛈️' do
      context 'with valid payments but fraud' do
        before do
          3.times do
            Payment.create!(valid_attributes)
          end
        end

        it 'does not create' do
          expect do
            post api_v1_payments_path, params: { payment: valid_attributes }, headers: headers
          end.to change(Payment, :count).by(1)

          expect(json_response['transaction_id']).to eq valid_attributes[:transaction_id]
          expect(json_response['recommendation']).to eq 'deny'
          expect(response.status).to eq 201
        end
      end
    end
  end
end
