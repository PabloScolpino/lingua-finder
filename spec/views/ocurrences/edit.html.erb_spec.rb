require 'rails_helper'

RSpec.describe "ocurrences/edit", type: :view do
  before(:each) do
    @ocurrence = assign(:ocurrence, Ocurrence.create!(
      :context => "MyString",
      :result => nil,
      :page => nil
    ))
  end

  it "renders the edit ocurrence form" do
    render

    assert_select "form[action=?][method=?]", ocurrence_path(@ocurrence), "post" do

      assert_select "input#ocurrence_context[name=?]", "ocurrence[context]"

      assert_select "input#ocurrence_result_id[name=?]", "ocurrence[result_id]"

      assert_select "input#ocurrence_page_id[name=?]", "ocurrence[page_id]"
    end
  end
end
