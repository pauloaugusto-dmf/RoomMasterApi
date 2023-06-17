module Cache
  class Setex < ApplicationService
    def initialize(key, value, expiration_time = nil)
      @key = key
      @value = value
      @expiration_time = expiration_time || default_expiration_time
      @redis = Connect.call
    end

    def call
      @redis.setex(@key, @expiration_time, @value)
    end

    private

    def default_expiration_time
      86_400
    end
  end
end
