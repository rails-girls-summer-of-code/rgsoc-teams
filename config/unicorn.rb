# http://michaelvanrooijen.com/articles/2011/06/01-more-concurrency-on-a-single-heroku-dyno-with-the-new-celadon-cedar-stack/

worker_processes 3 # amount of unicorn workers to spin up
timeout 30         # restarts workers that hang for 15 seconds

preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  # # https://coderwall.com/p/fprnhg
  # @sidekiq_pid ||= spawn('bundle exec sidekiq -c 2')
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)

  # SuckerPunch.config do
  #   queue name: :log_queue, worker: LogWorker, workers: 10
  # end

  # alternatively: https://github.com/brandonhilkert/sucker_punch
  #
  # # https://coderwall.com/p/fprnhg
  # Sidekiq.configure_client { |config| config.redis = { :size => 1 } }
  # Sidekiq.configure_server { |config| config.redis = { :size => 5 } }
end


