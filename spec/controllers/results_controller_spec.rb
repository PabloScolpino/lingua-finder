# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResultsController, type: :controller do
  let(:search) { create(:search) }
  let(:page) { create(:page) }

  let(:valid_attributes) do
    { word: 'la', context: 'mientras que la luna brillaba', page: page, search: search }
  end

  let(:invalid_attributes) do
    { not_word: 'bla', not_context: 'porque bla' }
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'brings a list of all results' do
      skip 'WIP'
      result = Result.create! valid_attributes
      get search_results_url, params: { search_id: search.id, word: result.word }, session: valid_session
      expect(assigns(:results)).to eq([result])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested result as @result' do
      skip 'WIP'
      result = Result.create! valid_attributes
      get :show, params: { id: result.to_param }, session: valid_session
      expect(assigns(:result)).to eq(result)
    end
  end
end
