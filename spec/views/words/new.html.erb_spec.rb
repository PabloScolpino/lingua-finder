require 'rails_helper'

RSpec.describe "words/new", type: :view do
  before(:each) do
    assign(:word, Word.new(
      :phrase => "MyString",
      :category => nil
    ))
  end

  it "renders new word form" do
    render

    assert_select "form[action=?][method=?]", words_path, "post" do

      assert_select "input#word_phrase[name=?]", "word[phrase]"

      assert_select "input#word_category_id[name=?]", "word[category_id]"
    end
  end
end
