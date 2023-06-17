module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user, only: [:show]

      def show
        if @current_user.id == params[:id].to_i
          render json: @current_user
        else
          render json: { error: 'unauthorized access' }, status: :unauthorized
        end
      end

      def create
        user = User.new(user_params)

        if user.save
          token = Jwt::Encode.call(user)
          render json: { token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
