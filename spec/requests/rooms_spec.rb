require 'rails_helper'

RSpec.describe '/rooms', type: :request do
  let(:role_admin) { create :role, :admin }
  let(:user) { create :user }
  let(:user_admin) { create :user, role: role_admin }
  let(:room) { create :room }

  describe 'GET /index' do
    context 'when user is authenticated' do
      before do
        room
        get '/api/v1/rooms', headers: authenticate_headers(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'returns 200, success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user information' do
        expect(response.body).to eq([room].to_json)
      end
    end

    context 'when user is not authenticated' do
      before do
        get '/api/v1/rooms', headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to eq({ error: 'invalid or expired authentication token' }.to_json)
      end
    end
  end

  describe 'GET /show' do
    context 'when user is authenticated' do
      before do
        get "/api/v1/rooms/#{room.id}", headers: authenticate_headers(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'returns 200, success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user information' do
        expect(response.body).to eq(room.to_json)
      end
    end

    context 'when user is not authenticated' do
      before do
        get "/api/v1/rooms/#{room.id}", headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to eq({ error: 'invalid or expired authentication token' }.to_json)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        { name: room.name, capacity: room.capacity }
      end

      before do
        post '/api/v1/rooms', params: { room: valid_params }, headers: authenticate_headers(user_admin), as: :json
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns 201, created' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new room' do
        expect do
          post '/api/v1/rooms', params: { room: valid_params }, headers: authenticate_headers(user_admin), as: :json
        end.to change(Room, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        { name: '', capacity: 1 }
      end

      before do
        post '/api/v1/rooms', params: { room: invalid_params }, headers: authenticate_headers(user_admin), as: :json
      end

      it 'returns 422, unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messager' do
        expect(response.body).to include('errors')
      end

      it 'does not create a new user' do
        expect do
          post '/api/v1/rooms', params: { room: invalid_params }, headers: authenticate_headers(user_admin), as: :json
        end.not_to change(Room, :count)
      end
    end

    context 'with unauthenticated user' do
      let(:valid_params) do
        { name: room.name, capacity: room.capacity }
      end

      before do
        post '/api/v1/rooms', params: { room: valid_params }, headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not create a new user' do
        expect do
          post '/api/v1/rooms', params: { room: valid_params }, headers: headers_json, as: :json
        end.not_to change(Room, :count)
      end
    end

    context 'with unauthorized user' do
      let(:valid_params) do
        { name: room.name, capacity: room.capacity }
      end

      before do
        post '/api/v1/rooms', params: { room: valid_params }, headers: authenticate_headers(user), as: :json
      end

      it 'returns 403, forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not create a new user' do
        expect do
          post '/api/v1/rooms', params: { room: valid_params }, headers: authenticate_headers(user), as: :json
        end.not_to change(Room, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      before do
        put "/api/v1/rooms/#{room.id}", params: { room: { name: 'other name' } },
                                        headers: authenticate_headers(user_admin),
                                        as: :json
        room.reload
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns 200, ok a success response and change the name' do
        expect(response).to have_http_status(:ok)
      end

      it 'change the name' do
        expect(room.name).to eq('other name')
      end
    end

    context 'with invalid parameters' do
      let(:original_name) { room.name }

      before do
        put "/api/v1/rooms/#{room.id}", params: { room: { name: '' } }, headers: authenticate_headers(user_admin),
                                        as: :json
        room.reload
      end

      it 'returns 422, unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messager' do
        expect(response.body).to include('errors')
      end

      it 'does not change the name' do
        expect(room.name).to eq(original_name)
      end
    end

    context 'with unauthenticated user' do
      let(:original_name) { room.name }

      before do
        put "/api/v1/rooms/#{room.id}", params: { room: { name: 'other name' } }, headers: headers_json, as: :json
        room.reload
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not change the name' do
        expect(room.name).to eq(original_name)
      end
    end

    context 'with unauthorized user' do
      let(:original_name) { room.name }

      before do
        put "/api/v1/rooms/#{room.id}", params: { room: { name: 'other name' } }, headers: authenticate_headers(user),
                                        as: :json
        room.reload
      end

      it 'returns 403, forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not change the name' do
        expect(room.name).to eq(original_name)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid parameters' do
      before do
        delete "/api/v1/rooms/#{room.id}", headers: authenticate_headers(user_admin), as: :json
      end
      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'returns 204, no content' do
        expect(response.status).to eq(204)
      end

      it 'destroys the room' do
        expect(Room.count).to eq(0)
      end
    end

    context 'with unauthenticated user' do
      before do
        delete "/api/v1/rooms/#{room.id}", headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not destroys the room' do
        expect(Room.count).to eq(1)
      end
    end

    context 'with unauthorized user' do
      before do
        delete "/api/v1/rooms/#{room.id}", headers: authenticate_headers(user), as: :json
      end

      it 'returns 403, forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not destroys the room' do
        expect(Room.count).to eq(1)
      end
    end
  end
end
