class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :timeoutable
  
  def fullname
  	self.fname + self.lname
  end

  def address
  	self.line1 + self.city + self.state + self.zip  	
  end

  def email_subscribe
    gibbon = Gibbon::API.new
    Gibbon::API.throws_exceptions = false
    self.email_contact = true 
    if !gibbon.lists.members(id: "450d7581dd", email: self.email)
      gibbon.lists.subscribe({:id => "450d7581dd", :email => {:email => self.email}, :merge_vars => {:FNAME => self.fname, :LNAME => self.lname}, :double_optin => false})
    end
  end
  def email_unsubscribe
    gibbon = Gibbon::API.new
    Gibbon::API.throws_exceptions = false
    self.email_contact = false 
    if gibbon.lists.members(id: "450d7581dd", email: self.email)
      gibbon.lists.unsubscribe({:id => "450d7581dd", :email => {:email => self.email}, :merge_vars => {:FNAME => self.fname, :LNAME => self.lname}, :double_optin => false})
    end
  end
  def sms_subscribe
    self.phone? ? self.sms_contact = true : false
  end
  def sms_unsubscribe
    self.sms_contact=false
  end
end
