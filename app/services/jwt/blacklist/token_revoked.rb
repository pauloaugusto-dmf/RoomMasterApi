module Jwt
  module Blacklist
    class TokenRevoked < ApplicationService
      def initialize(token)
        @token = token
      end

      def call
        !Cache::Exists.call(@token).zero?
      end
    end
  end
end
