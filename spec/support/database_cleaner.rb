RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true, reset_ids: false }
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
