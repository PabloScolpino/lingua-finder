require 'rails_helper'

RSpec.describe "results/edit", type: :view do
  before(:each) do
    @result = assign(:result, Result.create!(
      :word => "MyString",
      :search => nil
    ))
  end

  it "renders the edit result form" do
    render

    assert_select "form[action=?][method=?]", result_path(@result), "post" do

      assert_select "input#result_word[name=?]", "result[word]"

      assert_select "input#result_search_id[name=?]", "result[search_id]"
    end
  end
end
