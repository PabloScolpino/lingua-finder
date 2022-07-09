# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Search. As you add validations to Search, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SearchesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all searches as @searches' do
      search = Search.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:searches)).to eq([search])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested search as @search' do
      search = Search.create! valid_attributes
      get :show, params: { id: search.to_param }, session: valid_session
      expect(assigns(:search)).to eq(search)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested search as @search' do
      search = Search.create! valid_attributes
      get :edit, params: { id: search.to_param }, session: valid_session
      expect(assigns(:search)).to eq(search)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Search' do
        expect do
          post :create, params: { search: valid_attributes }, session: valid_session
        end.to change(Search, :count).by(1)
      end

      it 'assigns a newly created search as @search' do
        post :create, params: { search: valid_attributes }, session: valid_session
        expect(assigns(:search)).to be_a(Search)
        expect(assigns(:search)).to be_persisted
      end

      it 'redirects to the created search' do
        post :create, params: { search: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Search.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved search as @search' do
        post :create, params: { search: invalid_attributes }, session: valid_session
        expect(assigns(:search)).to be_a_new(Search)
      end

      it "re-renders the 'new' template" do
        post :create, params: { search: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested search' do
        search = Search.create! valid_attributes
        put :update, params: { id: search.to_param, search: new_attributes }, session: valid_session
        search.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested search as @search' do
        search = Search.create! valid_attributes
        put :update, params: { id: search.to_param, search: valid_attributes }, session: valid_session
        expect(assigns(:search)).to eq(search)
      end

      it 'redirects to the search' do
        search = Search.create! valid_attributes
        put :update, params: { id: search.to_param, search: valid_attributes }, session: valid_session
        expect(response).to redirect_to(search)
      end
    end

    context 'with invalid params' do
      it 'assigns the search as @search' do
        search = Search.create! valid_attributes
        put :update, params: { id: search.to_param, search: invalid_attributes }, session: valid_session
        expect(assigns(:search)).to eq(search)
      end

      it "re-renders the 'edit' template" do
        search = Search.create! valid_attributes
        put :update, params: { id: search.to_param, search: invalid_attributes }, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested search' do
      search = Search.create! valid_attributes
      expect do
        delete :destroy, params: { id: search.to_param }, session: valid_session
      end.to change(Search, :count).by(-1)
    end

    it 'redirects to the searches list' do
      search = Search.create! valid_attributes
      delete :destroy, params: { id: search.to_param }, session: valid_session
      expect(response).to redirect_to(searches_url)
    end
  end
end
