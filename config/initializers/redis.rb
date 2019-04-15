if Rails.env.production?
  $redis = Redis.new(
    :host => ENV['REDIS_HOST'],
    :port => ENV['REDIS_PORT'],
    :password => ENV['REDIS_PASSWORD']
  )
else
  $redis = Redis.new(host: 'localhost', port: 6379)
end
