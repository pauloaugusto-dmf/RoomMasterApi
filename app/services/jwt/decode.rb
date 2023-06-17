module Jwt
  class Decode < ApplicationService
    def initialize(token)
      @token = token
      @secret_key = Rails.application.secrets.secret_key_base
    end

    def call
      JWT.decode(@token, @secret_key).first
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT decode error: #{e.message}")
    end
  end
end
