require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  describe 'GET #version' do
    it 'returns http success' do
      get :version
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
