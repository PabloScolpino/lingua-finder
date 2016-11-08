require 'rails_helper'

RSpec.describe "words/edit", type: :view do
  before(:each) do
    @word = assign(:word, Word.create!(
      :phrase => "MyString",
      :category => nil
    ))
  end

  it "renders the edit word form" do
    render

    assert_select "form[action=?][method=?]", word_path(@word), "post" do

      assert_select "input#word_phrase[name=?]", "word[phrase]"

      assert_select "input#word_category_id[name=?]", "word[category_id]"
    end
  end
end
