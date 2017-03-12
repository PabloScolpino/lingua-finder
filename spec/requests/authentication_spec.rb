require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "GET /searches" do
    context 'not logged in' do
      it "redirects to login!" do
        get searches_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'login' do
    context 'valid authentication in google' do
      it 'redirects to search' do
        get root_path
        pending 'Not mocking omniauth authorization properly'
        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end
end
