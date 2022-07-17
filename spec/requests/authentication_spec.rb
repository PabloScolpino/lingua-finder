# frozen_string_literal: true

require 'rails_helper'

describe 'Authentication', type: :request do
  describe 'GET /searches' do
    context 'not logged in' do
      it 'redirects to login!' do
        get searches_path, params: {}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'login' do
    context 'valid authentication in google' do
      it 'redirects to search' do
        get root_path, params: {}
        pending 'Not mocking omniauth authorization properly'
        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end
end
