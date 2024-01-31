# frozen_string_literal: true

class Api::V1::PaymentsController < ApplicationController

  def create
    @payment = Payment.new(payment_params)
    @payment.recommendation = ::RecommendationService.new(payment: @payment, checker: :worst).recommend

    if @payment.save
      render json: @payment.to_json(only: [:transaction_id, :recommendation]), status: :created
    else
      render json: { errors: @payment.errors }, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:transaction_id, :merchant_id, :user_id, :card_number, :transaction_date, :transaction_amount, :device_id)
  end
end
