Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['YOUR_CONSUMER_KEY']
  config.consumer_secret = ENV['YOUR_CONSUMER_SECRET']
  config.access_token = ENV['USER_ACCESS_TOKEN']
  config.access_token_secret = ENV['USER_ACCESS_TOKEN_SECRET']
end