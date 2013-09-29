class ContactController < ApplicationController

  def contact_all # TODO: this needs to be changed to send_sms
    # validate that user is an admin
    redirect_to :root unless current_user && current_user.admin?
  end

  def send_all_message
    message = params[:message]
    numbers_to_sms = User.where(sms_contact: true).pluck(:phone)
    # if any of these numbers are nil, the text_contact call will fail and
    # return false
    numbers_to_sms.each { |number| text_contact(message, number) }
    redirect_to contact_all_path
  end

  def new_announcement
  end

  def make_announcement
    message = params[:message]
    Announcement.create!(body: message)
    flash[:success] = "Announcement successfully made."
    redirect_to new_announcement_path
  end
  
  private
  def text_contact(message, contact_number)
    if contact_number
      @twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      @twilio_client.account.sms.messages.create(
        :from => "+1#{ENV['TWILIO_NUMBER']}",
        :to => contact_number,
        :body => message
      )
      flash[:notice] = "Message sent!"
    else
      return false
    end
    return true
  end
end