module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = Jwt::Encode.call(user)
          render json: { token: token }
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def destroy
        token = request.headers['Authorization']&.split(' ')&.last
        if token.present? && valid_token?(token)
          Jwt::Blacklist::RevokeToken.call(token)
          render json: { message: 'Logout successful' }, status: :ok
        else
          render json: { error: 'Invalid token' }, status: :unprocessable_entity
        end
      end
    end
  end
end
