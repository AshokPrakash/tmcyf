require 'spec_helper'

describe "Retreats" do
  describe "GET /retreat" do
    it "displays the latest retreat if a retreat has been created" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      
      FactoryGirl.create :retreat
      get retreat_path
      response.status.should be(200)
    end
  end
end
