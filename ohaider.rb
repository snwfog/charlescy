require 'slim'
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
    get('/css/normalize.css') { render_assets 'normalize.css' }
    get('/css/style.css')     { render_assets 'style.css' }
    get('/css/style.css.map') { render_assets 'style.css.map' }

    get('/assets/images/:image_name')   { render_assets ''}
  end
end
