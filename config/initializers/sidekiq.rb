Sidekiq.strict_args!(false)

Sidekiq.configure_server do |config|
      config.redis = { url: ENV['SIDEKIQ_URL']}
end

