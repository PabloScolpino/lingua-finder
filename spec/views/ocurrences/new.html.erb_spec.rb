require 'rails_helper'

RSpec.describe "ocurrences/new", type: :view do
  before(:each) do
    assign(:ocurrence, Ocurrence.new(
      :context => "MyString",
      :result => nil,
      :page => nil
    ))
  end

  it "renders new ocurrence form" do
    render

    assert_select "form[action=?][method=?]", ocurrences_path, "post" do

      assert_select "input#ocurrence_context[name=?]", "ocurrence[context]"

      assert_select "input#ocurrence_result_id[name=?]", "ocurrence[result_id]"

      assert_select "input#ocurrence_page_id[name=?]", "ocurrence[page_id]"
    end
  end
end
