require 'rails_helper'

RSpec.describe "Results", type: :request do
  let(:search) { Search.create! ({query: 'durante el <?>'}) }

  describe "GET /searches/1/results/pepe" do
    it "works! (now write some real specs)" do
      get search_results_path({ search_id: search.id, word: 'pepe'})
      expect(response).to have_http_status(200)
    end
  end
end
