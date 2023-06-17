module Jwt
  class Encode < ApplicationService
    def initialize(user)
      @payload = { user_id: user.id }
      @secret_key = Rails.application.secrets.secret_key_base
    end

    def call
      JWT.encode(@payload, @secret_key)
    end
  end
end
