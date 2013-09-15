require 'spec_helper'

describe "retreats/index" do
  before(:each) do
    assign(:retreats, [
      stub_model(Retreat),
      stub_model(Retreat)
    ])
  end

  it "renders a list of retreats" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
