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

        body = response.parsed_body
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

        body = response.parsed_body
        expect(body['error']).to eq('Invalid credentials')
      end
    end
  end

  describe 'POST #logout' do
    context 'when token is valid' do
      it 'revokes the token and returns a success message' do
        delete '/api/v1/logout', headers: authenticate_headers(user)

        body = response.parsed_body

        expect(response).to have_http_status(:ok)
        expect(body).to eq({ 'message' => 'Logout successful' })
      end
    end

    context 'when token is invalid' do
      token = nil

      it 'returns an error message' do
        delete '/api/v1/logout', headers: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        body = response.parsed_body

        expect(response).to have_http_status(:unprocessable_entity)
        expect(body['error']).to eq('Invalid token')
      end
    end
  end
end
