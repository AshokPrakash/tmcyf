class PagesController < ApplicationController
	before_filter :authenticate_user!, :except => [:home, :about, :about_biblestudies, :about_tribes, :about_service, :about_socials, :about_officers, :about_contact, :events, :biblestudy, :account]

	def home
    url = 'http://www.heartlight.org/cgi-shl/todaysverse.cgi'
    data = Nokogiri::HTML(open(url))
    @votd = data.at_css(".todays-verse-verse").text
    @votdref = data.at_css(".todays-verse-ref").text
	end

  def about
  end

  def biblestudy
  end

  def account
  end

  def admin
  end

  def preferences
    @user = current_user
  end
  def update_preferences
    @user = current_user
    params['Facebook'] ? @user.facebook_contact=true : @user.facebook_contact=false
    params["email"] ? @user.email_subscribe : @user.email_unsubscribe 
    if params["SMS"]
      error_msg = "There was a problem subscribing you to our text alerts. Is there a valid phone number in your Profile?" 
      flash[:error] = error_msg unless @user.sms_subscribe 
    else
      @user.sms_unsubscribe
    end
    @user.save!
    redirect_to account_preferences_path
  end
end
