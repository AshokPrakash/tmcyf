require 'spec_helper'

describe "retreats/show" do
  before(:each) do
    @retreat = assign(:retreat, stub_model(Retreat))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
