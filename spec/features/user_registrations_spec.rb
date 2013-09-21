require 'spec_helper'

describe "UserRegistrations" do
  describe "Sign up page" do
    it "works" do
      visit "/register"
      fill_in "user_email", with: "bgmuthalaly@gmail.com"
      fill_in "user_password", with: "bertbert"
      fill_in "user_password_confirmation", with: "bertbert"
      click_button "Sign up"
      page.should have_content "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    end
  end

  describe "Sign in page" do
    before do
      @user = FactoryGirl.create(:user)
    end
    it "works" do
      visit "/login"
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password
      click_button "Sign in"
      page.should have_content "Signed in successfully"
    end
  end
end
