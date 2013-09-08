class PaymentsController < ApplicationController
  def index
    @credit_card = current_user.credit_card
    @unpaid_events = current_user.unpaid_events
  end
  def new
    @payment = Payment.new
  end
  def create
    @payment = Payment.create # should include the event id & current user
    @payment.event = Event.friendly.find(params[:event_id])
    # TODO: I think this is an anti-pattern? Try current_user.payment.build or
    # something to that effect
    @payment.user = current_user
    begin
      current_user.charge(amount: (@payment.event.cost * 100).to_i, description: "Payment for TMCYF #{@payment.event.title}")
      flash[:success] = "Payment has been made for #{@payment.event.title}" if @payment.save!
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
