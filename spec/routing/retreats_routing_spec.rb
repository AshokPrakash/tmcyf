require "spec_helper"

describe RetreatsController do
  before do
    FactoryGirl.create(:retreat)
  end
  describe "routing" do

    it "routes to #index" do
      get("/retreats").should route_to("retreats#index")
    end

    it "routes to #new" do
      get("/retreats/new").should route_to("retreats#new")
    end

    it "routes to #show" do
      get("/retreat").should route_to("retreats#show")
    end

    it "routes to #create" do
      post("/retreats").should route_to("retreats#create")
    end

    it "routes to #update" do
      put("/retreats/1").should route_to("retreats#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/retreats/1").should route_to("retreats#destroy", :id => "1")
    end

  end
end
