require 'gemoji'
require 'eldr-rendering'
require 'statsd-instrument'

module Ohaider
  module Helpers
    def render_assets asset_name
      StatsD.increment('rendering.assets.css') # Increment
      Rack::Response.new File.read(File.join(configuration.assets_path, 'css', asset_name)), 200, { 'Content-Type' => 'text/css' }
    end

    def render_emoji emoji_name
      emoji = Emoji.find_by_alias emoji_name.to_s
      raise "Cannot find emoji #{emoji_name}" if emoji.nil?
      StatsD.increment("rendering.assets.emoji.#{emoji.name}") # Increment
      image_path = "/assets/images/emoji/#{emoji.image_filename}"
      "<img alt='#{emoji.name}' src='#{image_path}' style='vertical-align:middle' width='20' height='20' />"
    end
  end
end