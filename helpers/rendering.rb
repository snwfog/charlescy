require 'gemoji'
require 'eldr-rendering'
require 'statsd-instrument'

module Ohaider
  module Helpers
    def render_assets asset_path
      StatsD.increment('rendering.assets.css') # Increment
      Rack::Response.new File.read(File.join(configuration.assets_path, asset_path)),
                         200, { 'Content-Type' => "#{get_mime(asset_path)}" }
    end

    def render_emoji emoji_name
      emoji = Emoji.find_by_alias emoji_name.to_s
      raise "Cannot find emoji #{emoji_name}" if emoji.nil?
      StatsD.increment("rendering.assets.emoji.#{emoji.name}") # Increment
      image_path = "/images/emoji/#{emoji.image_filename}"
      "<img alt='#{emoji.name}' src='#{image_path}' style='vertical-align:middle' width='20' height='20' />"
    end

    private
    def get_mime(asset_path)
      type = case File.extname(asset_path)
             when /png|jpe?g/
               'image'
             else
               'text'
             end
      "#{type}/#{File.extname(asset_path)[1..-1]}"
    end
  end
end