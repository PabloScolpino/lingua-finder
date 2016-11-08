require 'rails_helper'

RSpec.describe "searches/index", type: :view do
  before(:each) do
    assign(:searches, [
      Search.create!(
        :query => "Query"
      ),
      Search.create!(
        :query => "Query"
      )
    ])
  end

  it "renders a list of searches" do
    render
    assert_select "tr>td", :text => "Query".to_s, :count => 2
  end
end
