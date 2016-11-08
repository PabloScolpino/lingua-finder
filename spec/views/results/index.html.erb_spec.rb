require 'rails_helper'

RSpec.describe "results/index", type: :view do
  before(:each) do
    assign(:results, [
      Result.create!(
        :word => "Word",
        :search => nil
      ),
      Result.create!(
        :word => "Word",
        :search => nil
      )
    ])
  end

  it "renders a list of results" do
    render
    assert_select "tr>td", :text => "Word".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
