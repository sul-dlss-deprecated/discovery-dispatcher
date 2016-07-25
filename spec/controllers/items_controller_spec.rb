require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe 'GET #new' do
    it 'returns http success' do
      request.accept = "application/json"
      get :new, {:type=>'index',:druid=>'druid:oo000oo0001',:targets=>['target1']}
      expect(response).to have_http_status(:success)
    end
    it 'returns 500 error if there is no druid provided' do
      request.accept = "application/json"
      get :new, {:type=>'index',:druid=>nil,:targets=>['target1']}
      expect(response).to have_http_status(:error)
    end
  end
end
