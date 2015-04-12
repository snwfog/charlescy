require 'slim'
require 'statsd-instrument'
require 'eldr'
require 'eldr-rendering'
require 'eldr-assets'
require_relative 'helpers/rendering'

module Ohaider
  class Charlescy < Eldr::App
    include Eldr::Rendering
    include Eldr::Assets
    include Ohaider::Helpers

    # set :assets_path, File.join(__dir__, 'assets')
    set :css_assets_folder, '/assets/css'
    set :views_dir, File.join(__dir__, 'views')
    set :asset_stamp, false

    get('/') { render 'index.slim' }
  end

  class ErrorMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue Exception
      StatsD.increment("exceptions.global")
      [400, {'Content-Type' => 'text/html'}, ['<p>Something when wrong.</p>']]
    end
  end
end
