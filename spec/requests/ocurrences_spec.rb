require 'rails_helper'

RSpec.describe "Ocurrences", type: :request do
  describe "GET /ocurrences" do
    it "works! (now write some real specs)" do
      get ocurrences_path
      expect(response).to have_http_status(200)
    end
  end
end
