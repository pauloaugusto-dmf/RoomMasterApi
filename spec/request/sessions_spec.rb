require 'rails_helper'

RSpec.describe '/sessions', type: :request do
  let(:user) { create :user, password: 'password' }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/api/v1/login', params:
        {
          email: user.email,
          password: 'password'
        }, headers: headers_json, as: :json

        expect(response).to have_http_status(:success)

        body = JSON.parse(response.body)
        expect(body['token']).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        post '/api/v1/login', params:
        {
          email: user.email,
          password: 'wrong_password'
        }, headers: headers_json, as: :json

        expect(response).to have_http_status(:unauthorized)

        body = JSON.parse(response.body)
        expect(body['error']).to eq('Invalid credentials')
      end
    end
  end
end
