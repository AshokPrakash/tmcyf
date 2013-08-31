class CreditCardsController < ApplicationController
  # This is necessary because we have some ajax submits in here that don't
  # currently submit the authenticity token. I'm not yet sure of the right way
  # to avoid doing this.
  skip_before_action :verify_authenticity_token 
  def new
  end
  def create
    
    begin
      # user.new_card will catch any exceptions from params[:stripe_token]
      # being nil, or problems with the Stripe API re: that specific card
      @default_card = current_user.new_card(params[:stripe_token]).default_card
      flash[:success] = "New card successfully saved" if @default_card
    rescue => e # to rescue any exceptions from the new_card call
      # TODO: We can give the user various more useful descriptions of what went
      # wrong, like an insufficient balance or an invalid card number
      logger.info(e)
      flash[:error] = "There was a problem processing your request."
      redirect_to account_payments_path and return
    end
    respond_to do |format|
      format.html { redirect_to account_payments_path }
      format.js
    end
    # render html: "<div id='default_card'> #{@card.type} #{@card.last4}</div>"
    # TODO: what exactly should we render here? We need to replace the default
    # card div in payments/index with the returned default card object
    # This could be a format.js call or a render call, with an html fragment
    # returned.
  end

  def show
    begin
      @card = current_user.credit_card
    rescue => e
      redirect_to account_payments_path, error: e
    end
  end

  def destroy
  end
end
