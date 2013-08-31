class PaymentsController < ApplicationController
  def index
    @credit_card = current_user.credit_card
    events_requiring_payment = Event.where.not(cost: nil)
    events_paid_for = current_user.payments.collect { |p| p.event }
    # the set difference of two arrays a & b in ruby is (a - b) | (b - a)
    @unpaid_events = events_requiring_payment - events_paid_for | events_paid_for - events_requiring_payment
  end
  def new
    @payment = Payment.new
  end
  def create
    @payment = Payment.create # should include the event id & current user
    @payment.event = Event.friendly.find(params[:event_id])
    begin
      current_user.charge(amount: (@payment.event.cost * 100).to_i, description: "Payment for TMCYF #{@payment.event.title}")
      flash[:success] = "Payment has been made for #{@payment.event.title}"
      redirect_to account_payments_path
    rescue => e
      # TODO: More informative error messages
      logger.info(e)
      flash[:error] = "There was a problem processing your payment"
      redirect_to account_payments_path
    end
  end
  private
    def payment_params
      params.require(:payment).permit(:event_id)
    end
end
