# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WordsController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Word. As you add validations to Word, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WordsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all words as @words' do
      word = Word.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:words)).to eq([word])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested word as @word' do
      word = Word.create! valid_attributes
      get :show, params: { id: word.to_param }, session: valid_session
      expect(assigns(:word)).to eq(word)
    end
  end

  describe 'GET #new' do
    it 'assigns a new word as @word' do
      get :new, params: {}, session: valid_session
      expect(assigns(:word)).to be_a_new(Word)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested word as @word' do
      word = Word.create! valid_attributes
      get :edit, params: { id: word.to_param }, session: valid_session
      expect(assigns(:word)).to eq(word)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Word' do
        expect do
          post :create, params: { word: valid_attributes }, session: valid_session
        end.to change(Word, :count).by(1)
      end

      it 'assigns a newly created word as @word' do
        post :create, params: { word: valid_attributes }, session: valid_session
        expect(assigns(:word)).to be_a(Word)
        expect(assigns(:word)).to be_persisted
      end

      it 'redirects to the created word' do
        post :create, params: { word: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Word.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved word as @word' do
        post :create, params: { word: invalid_attributes }, session: valid_session
        expect(assigns(:word)).to be_a_new(Word)
      end

      it "re-renders the 'new' template" do
        post :create, params: { word: invalid_attributes }, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested word' do
        word = Word.create! valid_attributes
        put :update, params: { id: word.to_param, word: new_attributes }, session: valid_session
        word.reload
        skip('Add assertions for updated state')
      end

      it 'assigns the requested word as @word' do
        word = Word.create! valid_attributes
        put :update, params: { id: word.to_param, word: valid_attributes }, session: valid_session
        expect(assigns(:word)).to eq(word)
      end

      it 'redirects to the word' do
        word = Word.create! valid_attributes
        put :update, params: { id: word.to_param, word: valid_attributes }, session: valid_session
        expect(response).to redirect_to(word)
      end
    end

    context 'with invalid params' do
      it 'assigns the word as @word' do
        word = Word.create! valid_attributes
        put :update, params: { id: word.to_param, word: invalid_attributes }, session: valid_session
        expect(assigns(:word)).to eq(word)
      end

      it "re-renders the 'edit' template" do
        word = Word.create! valid_attributes
        put :update, params: { id: word.to_param, word: invalid_attributes }, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested word' do
      word = Word.create! valid_attributes
      expect do
        delete :destroy, params: { id: word.to_param }, session: valid_session
      end.to change(Word, :count).by(-1)
    end

    it 'redirects to the words list' do
      word = Word.create! valid_attributes
      delete :destroy, params: { id: word.to_param }, session: valid_session
      expect(response).to redirect_to(words_url)
    end
  end
end
