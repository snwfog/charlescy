require 'rubygems'
require 'bundler/setup'

require 'sprockets'

require_relative 'config/statsd'
require_relative 'ohaider'

# ENV['RACK_ENV'] = 'production'

logger = Logger.new('log/development.log')
logger.debug ENV.inspect

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets'
  environment.logger = logger
  run environment
end

map '/' do
  # use Ohaider::ErrorMiddleware
  run Ohaider::Charlescy
end
