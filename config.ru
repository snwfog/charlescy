require 'rubygems'
require 'bundler/setup'

require 'sprockets'
require 'logger'

require_relative 'config/statsd'
require_relative 'ohaider'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'assets'
  environment.logger = Logger.new('log/development.log')
  run environment
end

map '/' do
  run Ohaider::Charlescy
end
