module Authenticable
  extend ActiveSupport::Concern

  def authenticate_user
    token = extract_token(request)
    if token && valid_token?(token)
      decoded_token = decode_token(token)
      user_id = decoded_token['user_id']
      @current_user = User.find(user_id)
    else
      render json: { error: 'invalid or expired authentication token' }, status: :unauthorized
    end
  end

  private

  def extract_token(request)
    request.headers['Authorization']&.split(' ')&.last
  end

  def valid_token?(token)
    Jwt::Valid.call(token)
  end

  def decode_token(token)
    Jwt::Decode.call(token)
  end
end
