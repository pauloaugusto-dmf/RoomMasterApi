module Api
  module V1
    class RoomsController < ApplicationController
      before_action :authenticate_user
      before_action :authorizable_admin_user, only: %i[create update destroy]
      before_action :set_room, only: %i[show update destroy]

      def index
        @rooms = Room.all
        render json: @rooms, status: :ok
      end

      def show
        render json: @room, status: :ok
      end

      def create
        @room = Room.new(room_params)

        if @room.save
          render json: @room, status: :created, location: api_v1_rooms_url(@room)
        else
          render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @room.update(room_params)
          render json: @room, status: :ok
        else
          render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @room.destroy
      end

      private

      def set_room
        @room = Room.find(params[:id])
      end

      def room_params
        params.require(:room).permit(:name, :capacity)
      end
    end
  end
end
