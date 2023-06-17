module Cache
  class Get < ApplicationService
    def initialize(key)
      @key = key
      @redis = Connect.call
    end

    def call
      @redis.get(key)
    end
  end
end
