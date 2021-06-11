require 'rails_helper'

describe 'API receives request for' do
  context 'creating a new charge' do
    it 'and it\'s succesful' do
      
      post '/api/v1/charge_orders/'

      expect(response).to have_http_status :created # 201
    end
  end
end