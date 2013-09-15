require 'spec_helper'

describe "retreats/new" do
  before(:each) do
    assign(:retreat, stub_model(Retreat).as_new_record)
  end

  it "renders new retreat form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", retreats_path, "post" do
    end
  end
end
