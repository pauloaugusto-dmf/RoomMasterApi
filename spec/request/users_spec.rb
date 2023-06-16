require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { build :user }

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        { name: user.name, email: user.email, password: user.password }
      end

      it 'creates a new user' do
        expect do
          post '/api/v1/users', params: { user: valid_params }, headers: headers_json, as: :json
        end.to change(User, :count).by(1)
      end

      it 'returns a success response with token' do
        post '/api/v1/users', params: { user: valid_params }, headers: headers_json, as: :json
        expect(response).to have_http_status(:created)
        expect(response.body).to include('token')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        { name: '', email: 'invalid_email', password: 'short' }
      end

      it 'does not create a new user' do
        expect do
          post '/api/v1/users', params: { user: invalid_params }, headers: headers_json, as: :json
        end.not_to change(User, :count)
      end

      it 'returns an unprocessable entity response with errors' do
        post '/api/v1/users', params: { user: invalid_params }, headers: headers_json, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('errors')
      end
    end
  end
end
