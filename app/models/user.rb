class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable
  
  def fullname
  	self.fname + " " + self.lname
  end

  def address
  	self.line1 + self.city + self.state + self.zip  	
  end

  def email_subscribe
    gibbon = Gibbon::API.new
    Gibbon::API.throws_exceptions = false
    self.email_contact = true 
      gibbon.lists.subscribe({:id => ENV['MAILCHIMP_CAMPAIGN_ID'], :email => {:email => self.email}, :merge_vars => {:FNAME => self.fname, :LNAME => self.lname}, :double_optin => false})
  end
  def email_unsubscribe
    gibbon = Gibbon::API.new
    Gibbon::API.throws_exceptions = false
    self.email_contact = false
      gibbon.lists.unsubscribe({:id => ENV['MAILCHIMP_CAMPAIGN_ID'], :email => {:email => self.email}, :merge_vars => {:FNAME => self.fname, :LNAME => self.lname}, :double_optin => false})
  end
  def sms_subscribe
    self.phone? ? self.sms_contact = true : false
  end
  def sms_unsubscribe
    self.sms_contact=false
  end
end
