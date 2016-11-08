require 'rails_helper'

RSpec.describe "words/index", type: :view do
  before(:each) do
    assign(:words, [
      Word.create!(
        :phrase => "Phrase",
        :category => nil
      ),
      Word.create!(
        :phrase => "Phrase",
        :category => nil
      )
    ])
  end

  it "renders a list of words" do
    render
    assert_select "tr>td", :text => "Phrase".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
