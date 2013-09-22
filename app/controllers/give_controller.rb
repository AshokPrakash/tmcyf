class GiveController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :new, :create]

	def index
	end

	def new		
	end

	def create
  @amount = params['amount'].to_i * 100


  customer = Stripe::Customer.create(
    :email => 'donation@tmcyf.org',
    :card =>  params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )
  flash[:success] = "Thanks for your donation!"
  redirect_to give_index_path

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to give_index_path		
		
	end
end
