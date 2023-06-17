module Cache
  class Delete < ApplicationService
    def initialize(key)
      @key = key
      @redis = Connect.call
    end

    def call
      @redis.del(@key)
    end
  end
end
