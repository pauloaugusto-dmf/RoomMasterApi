module Jwt
  module Blacklist
    class RevokeToken < ApplicationService
      def initialize(token)
        @token = token
        @redis = Redis.new
      end

      def call
        Cache::Setex.call(@token, 'revoked', expiration_time)
      end

      private

      def expiration_time
        86_400
      end
    end
  end
end
