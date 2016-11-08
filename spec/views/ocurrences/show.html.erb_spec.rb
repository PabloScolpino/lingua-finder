require 'rails_helper'

RSpec.describe "ocurrences/show", type: :view do
  before(:each) do
    @ocurrence = assign(:ocurrence, Ocurrence.create!(
      :context => "Context",
      :result => nil,
      :page => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Context/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
