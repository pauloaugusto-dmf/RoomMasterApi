module Jwt
  class Valid < ApplicationService
    def initialize(token)
      @token = token
      @secret_key = Rails.application.secrets.secret_key_base
    end

    def call
      JWT.decode(@token, @secret_key)
      true
    rescue JWT::DecodeError, JWT::ExpiredSignature
      false
    end
  end
end
