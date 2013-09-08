class PagesController < ApplicationController
	before_filter :authenticate_user!, :except => [:home, :about, :about_biblestudies, :about_tribes, :about_service, :about_socials, :about_officers, :about_contact, :events, :biblestudy, :privacy_policy]

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
    @completion_percentage = current_user.profile_completion_percentage
    @paid_events = current_user.paid_events
    @dues_paid = current_user.dues_paid?
    @has_selected_contact_preference = current_user.has_selected_contact_preference?
  end

  def admin
    redirect_to :root unless current_user && current_user.admin?
    @fbname = User.where(facebook_contact: true).collect { |user| user.fullname }
  end

  def preferences
    @user = current_user
  end

  def privacy_policy
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
    flash[:notice] = "Preferences saved!"
    redirect_to account_preferences_path
  end
end
