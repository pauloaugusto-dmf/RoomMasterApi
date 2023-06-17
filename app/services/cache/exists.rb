module Cache
  class Exists < ApplicationService
    def initialize(key)
      @key = key
      @redis = Connect.call
    end

    def call
      @redis.exists(@key)
    end
  end
end
