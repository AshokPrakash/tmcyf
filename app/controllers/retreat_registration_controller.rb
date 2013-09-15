class RetreatRegistrationController < ApplicationController
  def create
    @user = current_user
  end
end
