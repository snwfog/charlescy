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

    set :assets_path, File.join(__dir__, 'assets')
    set :views_dir, File.join(__dir__, 'views')
    set :asset_stamp, false

    get('/')                  { render 'index.slim' }
    get('/css/normalize.css') { render_assets '/css/normalize.css' }
    get('/css/style.css')     { render_assets '/css/style.css' }
    get('/css/style.css.map') { render_assets '/css/style.css.map' }
    get('/images/emoji/**')   { |req| render_assets req['eldr.request'].path }
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
