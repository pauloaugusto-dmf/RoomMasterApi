module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :authenticate_user
      before_action :set_reservation, only: %i[show update destroy]

      def index
        @reservations = @current_user.reservations.all
          .ransack(params[:q])
          .result(distinct: true)
          .page(params[:page])
          .per(params[:page_size])

        render json: ReservationsSerializer.collection_as_json(@reservations)
      end

      def show
        render json: @reservation, status: :ok
      end

      def create
        @reservation = @current_user.reservations.create(reservation_params)
        if @reservation.save
          render json: @reservation, status: :created, location: api_v1_reservations_url(@reservation)
        else
          render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @reservation.update(reservation_params)
          render json: @reservation, status: :ok
        else
          render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @reservation.destroy
      end

      private

      def set_reservation
        @reservation = @current_user.reservations.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "reservation not registered or you don't have access to it" },
               status: :unprocessable_entity
      end

      def reservation_params
        params.require(:reservation).permit(:room_id, :start_time, :end_time)
      end
    end
  end
end
