module Cache
  class Set < ApplicationService
    def initialize(key, value)
      @key = key
      @value = value
      @redis = Connect.call
    end

    def call
      @redis.setex(@key, @value)
    end
  end
end
