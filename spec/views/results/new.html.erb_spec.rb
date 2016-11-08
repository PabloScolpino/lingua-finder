require 'rails_helper'

RSpec.describe "results/new", type: :view do
  before(:each) do
    assign(:result, Result.new(
      :word => "MyString",
      :search => nil
    ))
  end

  it "renders new result form" do
    render

    assert_select "form[action=?][method=?]", results_path, "post" do

      assert_select "input#result_word[name=?]", "result[word]"

      assert_select "input#result_search_id[name=?]", "result[search_id]"
    end
  end
end
