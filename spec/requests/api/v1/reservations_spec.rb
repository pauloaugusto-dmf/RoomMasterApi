require 'rails_helper'

RSpec.describe 'Api::V1::Reservations', type: :request do
  let(:user) { create :user }
  let(:room) { create :room }
  let(:other_room) { create :room }
  let(:reservation) { create :reservation, user: user }
  let(:other_reservation) { create :reservation }

  describe 'GET /index' do
    context 'when user is authenticated' do
      before do
        reservation
        get '/api/v1/reservations', headers: authenticate_headers(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'returns 200, success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user information' do
        expect(response.body).to eq([reservation].to_json)
      end
    end

    context 'when user is not authenticated' do
      before do
        get '/api/v1/reservations', headers: headers_json, as: :json
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
        get "/api/v1/reservations/#{reservation.id}", headers: authenticate_headers(user)
      end

      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'returns 200, success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the user information' do
        expect(response.body).to eq(reservation.to_json)
      end
    end

    context 'when user is not authenticated' do
      before do
        get "/api/v1/reservations/#{reservation.id}", headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to eq({ error: 'invalid or expired authentication token' }.to_json)
      end
    end

    context 'when the user is not responsible for the reservation' do
      before do
        get "/api/v1/reservations/#{other_reservation.id}", headers: authenticate_headers(user)
      end

      it 'returns 422, unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messager' do
        expect(response.body).to eq({ error: "reservation not registered or you don't have access to it" }.to_json)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        { room_id: room.id, start_time: reservation.start_time, end_time: reservation.end_time }
      end

      before do
        post '/api/v1/reservations', params: { reservation: valid_params }, headers: authenticate_headers(user),
                                     as: :json
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns 201, created' do
        expect(response).to have_http_status(:created)
      end

      it 'creates a new room' do
        expect do
          post '/api/v1/reservations', params: { reservation: valid_params }, headers: authenticate_headers(user),
                                       as: :json
        end.to change(Reservation, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        { room_id: '', start_time: reservation.start_time, end_time: reservation.end_time }
      end

      before do
        post '/api/v1/reservations', params: { reservation: invalid_params }, headers: authenticate_headers(user),
                                     as: :json
      end

      it 'returns 422, unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messager' do
        expect(response.body).to include('errors')
      end

      it 'does not create a new user' do
        expect do
          post '/api/v1/reservations', params: { reservation: invalid_params }, headers: authenticate_headers(user),
                                       as: :json
        end.not_to change(Reservation, :count)
      end
    end

    context 'with unauthenticated user' do
      let(:valid_params) do
        { room_id: room.id, start_time: reservation.start_time, end_time: reservation.end_time }
      end

      before do
        post '/api/v1/reservations', params: { room: valid_params }, headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not create a new user' do
        expect do
          post '/api/v1/reservations', params: { room: valid_params }, headers: headers_json, as: :json
        end.not_to change(Reservation, :count)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      before do
        put "/api/v1/reservations/#{reservation.id}", params: { reservation: { room_id: other_room.id } },
                                                      headers: authenticate_headers(user),
                                                      as: :json
        reservation.reload
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'returns 200, ok a success response and change the name' do
        expect(response).to have_http_status(:ok)
      end

      it 'change the name' do
        expect(reservation.room.id).to eq(other_room.id)
      end
    end

    context 'with invalid parameters' do
      let(:original_room) { reservation.room.id }

      before do
        put "/api/v1/reservations/#{reservation.id}", params: { reservation: { room_id: '' } },
                                                      headers: authenticate_headers(user),
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
        expect(reservation.room.id).to eq(original_room)
      end
    end

    context 'with unauthenticated user' do
      let(:original_room) { reservation.room.id }

      before do
        put "/api/v1/reservations/#{reservation.id}", params: { reservation: { room_id: other_room.id } },
                                                      headers: headers_json, as: :json
        reservation.reload
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not change the name' do
        expect(reservation.room.id).to eq(original_room)
      end
    end

    context 'when the user is not responsible for the reservation' do
      let(:original_room) { reservation.room.id }

      before do
        put "/api/v1/reservations/#{other_reservation.id}", params: {
                                                              reservation: { room_id: other_room.id }
                                                            },
                                                            headers: authenticate_headers(user), as: :json
        reservation.reload
      end

      it 'returns 422, unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not change the name' do
        expect(reservation.room.id).to eq(original_room)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid parameters' do
      before do
        delete "/api/v1/reservations/#{reservation.id}", headers: authenticate_headers(user), as: :json
      end
      it 'renders a successful response' do
        expect(response).to be_successful
      end

      it 'returns 204, no content' do
        expect(response.status).to eq(204)
      end

      it 'destroys the reservation' do
        expect(Reservation.count).to eq(0)
      end
    end

    context 'with unauthenticated user' do
      before do
        delete "/api/v1/reservations/#{reservation.id}", headers: headers_json, as: :json
      end

      it 'returns 401, unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not destroys the reservation' do
        expect(Reservation.count).to eq(1)
      end
    end

    context 'when the user is not responsible for the reservation' do
      before do
        delete "/api/v1/reservations/#{other_reservation.id}", headers: authenticate_headers(user), as: :json
      end

      it 'returns 422, unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messager' do
        expect(response.body).to include('error')
      end

      it 'does not destroys the reservation' do
        expect(Reservation.count).to eq(1)
      end
    end
  end
end
