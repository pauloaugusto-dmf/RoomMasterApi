require 'jwt'

module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)

        if user.save
          token = generate_jwt_token(user)
          render json: { token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

      def generate_jwt_token(user)
        payload = { user_id: user.id }
        secret_key = Rails.application.secrets.secret_key_base
        JWT.encode(payload, secret_key)
      end
    end
  end
end
