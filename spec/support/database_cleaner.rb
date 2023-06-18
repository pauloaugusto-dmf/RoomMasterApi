# frozen_string_literal: true

RSpec.configure do |config|
  # Limpeza do Redis
  config.before(:suite) do
    DatabaseCleaner[:redis].db = Redis.new(url: ENV.fetch('REDIS_URL', nil))
    DatabaseCleaner[:redis].strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner[:redis].start
  end

  config.after(:each) do
    DatabaseCleaner[:redis].clean
  end

  config.after(:suite) do
    DatabaseCleaner[:redis].clean_with(:deletion)
  end

  # Limpeza do ActiveRecord
  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end

  config.after(:suite) do
    DatabaseCleaner[:active_record].clean_with(:truncation)
  end
end
