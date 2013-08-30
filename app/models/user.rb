class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable
  has_many :payments
  
  def fullname
  	self.fname ? self.fname + " " + self.lname : nil
  end

  def address
  	self.line1 + self.city + self.state + self.zip
  end

  def new_card(stripe_token)
    begin
      raise "No stripe token submitted" unless stripe_token
      if self.stripe_id
        customer = Stripe::Customer.retrieve(self.stripe_id)
        customer.cards.create(card: stripe_token)
      else
        customer = Stripe::Customer.create(
          description: self.fullname,
          card: stripe_token
        )
        self.stripe_id = customer.id
      end
      self.save
      customer
    rescue Stripe::CardError => e
      # catch stripe error here
      # can we console.log an exception? 
      # should we raise the exception again to allow it to be passed on to the
      # controller or the view?
      logger.info(e)
      raise
    end
  end

  def charge(amount: nil, description: nil)
    # TODO: validate that there are no decimals in the amount
    raise "There is no credit card saved for this account" unless self.stripe_id 
    begin
      Stripe::Charge.create(
        amount: amount, # amount in cents, again
        currency: "usd",
        customer: self.stripe_id,
        description: description
      )
    rescue => e
      logger.info(e)
    end
  end

  def credit_card
    Stripe::Customer.retrieve(self.stripe_id).default_card if self.stripe_id
  end


  def email_subscribe
    gibbon = Gibbon::API.new
    Gibbon::API.throws_exceptions = false
    self.email_contact = true 
    if !gibbon.lists.members(id: ENV['MAILCHIMP_CAMPAIGN_ID'], email: self.email)
      gibbon.lists.subscribe(id: ENV['MAILCHIMP_CAMPAIGN_ID'], 
                             email: {email: self.email},
                             merge_vars: {FNAME: self.fname, LNAME: self.lname},
                             double_optin: false)
    end
  end
  def email_unsubscribe
    gibbon = Gibbon::API.new
    Gibbon::API.throws_exceptions = false
    self.email_contact = false 
    if gibbon.lists.members(id: ENV['MAILCHIMP_CAMPAIGN_ID'], email: self.email)
      gibbon.lists.unsubscribe(id: ENV['MAILCHIMP_CAMPAIGN_ID'], 
                             email: {email: self.email},
                             merge_vars: {FNAME: self.fname, LNAME: self.lname},
                             double_optin: false)
    end
  end
  def sms_subscribe
    self.phone? ? self.sms_contact = true : false
  end
  def sms_unsubscribe
    self.sms_contact=false
  end
end
