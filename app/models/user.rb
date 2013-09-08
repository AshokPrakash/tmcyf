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
        customer.default_card = customer.cards.create(card: stripe_token)
        customer.save
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
    # instead of saving this in the database, we query Stripe each time we want
    # to get the value of the user's current card
    Stripe::Customer.retrieve(id: self.stripe_id, expand: ['default_card']).default_card if self.stripe_id
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

  def dues_paid?
    this_years_dues = Event.where(dues: true).detect do |dues|
      dues.startdt.year.equal? DateTime.now.year
    end
    self.paid_events.include? this_years_dues
  end

  def unpaid_events
    paid_events = self.paid_events 
    events_requiring_payment = Event.where.not(cost: nil)
    # the set difference of two arrays a & b in ruby is (a - b) | (b - a)
    events_requiring_payment - paid_events | paid_events - events_requiring_payment
  end

  def paid_events
    # TODO: the delete_if call is required to trim payments that have been made
    # for events which have since been deleted. It's important to keep record
    # of these payments, so they shouldn't be destroyed in the database, but
    # their associated events return nil in the database. I'll keep thinking
    # about the best way to handle this. 
    self.payments.collect { |p| p.event }.delete_if { |event| event.nil? }
  end

  def has_selected_contact_preference?
    [ :email_contact, :facebook_contact, :sms_contact ].any? do |c|
      self[c]
    end
  end
  def profile_completion_percentage
    # TODO: We want to avoid hardcoding this; how do we link the elements  of
    # the required profile items array to the contents of the profile form?
    # If we keep this hardcoded, every update of the profile form will require
    # this to be updated, or else we'll break the profile_completion_percentage
    # indicator
    required_profile_items = [ :email, :fname, :lname, :phone, :gender, :birthday, :city, :state, :zip, :shirtsize, :email_contact, :facebook_contact, :sms_contact ]
    total = required_profile_items.size
    completed = 0.0
    # This method is tricky because the database does not reliably return "nil" from
    # profile items that are semantically "empty."
    # This debugging code helped me understand which profile items I can't reliably use nil
    # to detect.
    required_profile_items.each do |k| 
     logger.info self[k]
     logger.info self[k].class
     logger.info "#{k} #{ self[k].nil? ? "is nil" : "is not nil" }"
    end
    # TODO: there is DEFINITELY a cleaner way to do this
    required_profile_items.each do |k|
      item = self[k]
      # TODO: annoyingly, the DateTime class does not respond to the .empty?
      # method, hence this stupid special case check. Figure out a better way
      # to do this. 
      if item.respond_to? :empty?
        completed += 1 unless item.empty? or item.nil? 
      else
        completed += 1 unless item.nil?
      end
    end
    # calculate the average, round the result
    ((completed / total)* 100).round 
  end
end
