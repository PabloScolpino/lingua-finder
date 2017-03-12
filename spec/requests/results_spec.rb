require 'rails_helper'

RSpec.describe "Results", type: :request do

  let(:search) { create(:search) }

  describe "GET /searches/1/results/pepe" do

    context 'signed in' do
      it "works!" do
        get search_results_path({ search_id: search.id, word: 'pepe'})
        pending 'not mocking omniauth properly'
        expect(response).to have_http_status(200)
      end
    end
  end
end
