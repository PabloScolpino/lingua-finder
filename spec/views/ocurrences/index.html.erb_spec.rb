require 'rails_helper'

RSpec.describe "ocurrences/index", type: :view do
  before(:each) do
    assign(:ocurrences, [
      Ocurrence.create!(
        :context => "Context",
        :result => nil,
        :page => nil
      ),
      Ocurrence.create!(
        :context => "Context",
        :result => nil,
        :page => nil
      )
    ])
  end

  it "renders a list of ocurrences" do
    render
    assert_select "tr>td", :text => "Context".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
