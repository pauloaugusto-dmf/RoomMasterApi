module Cache
  class Connect < ApplicationService
    def call
      Redis.new(url: ENV.fetch('REDIS_URL', nil))
    end
  end
end
