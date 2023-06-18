require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { build :user }
  let(:current_user1) { create :user }
  let(:current_user2) { create :user }
  let(:role) { create :role }

  describe 'GET #show' do
    context 'when user is authenticated and accessing own information' do
      before do
        get "/api/v1/users/#{current_user1.id}", headers: authenticate_headers(current_user1)
      end

      it 'returns the user information' do
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(current_user1.to_json)
      end
    end

    context 'when user is authenticated but accessing other user information' do
      before do
        get "/api/v1/users/#{current_user1.id}", headers: authenticate_headers(current_user2)
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ error: 'unauthorized access' }.to_json)
      end
    end

    context 'when user is not authenticated' do
      before do
        get "/api/v1/users/#{current_user1.id}", headers: headers_json, as: :json
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ error: 'invalid or expired authentication token' }.to_json)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        { name: user.name, email: user.email, password: user.password, role_id: role.id }
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
