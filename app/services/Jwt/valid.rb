module Jwt
  class Encode < ApplicationService
    def initialize(token)
      @token = token
      @secret_key = Rails.application.secrets.secret_key_base
    end

    def call
      JWT.valid?(@token, @secret_key)
    end
  end
end
