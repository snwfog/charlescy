require 'gemoji'
require 'statsd-instrument'
require 'eldr/rendering/tag_helpers'

module Ohaider
  module Helpers
    include Eldr::Rendering::Tags

    def render_emoji emoji_name
      emoji = Emoji.find_by_alias emoji_name.to_s
      raise "Cannot find emoji #{emoji_name}" if emoji.nil?
      # StatsD.increment("rendering.assets.emoji.#{emoji.name}") # Increment
      image_path = "/assets/images/emoji/#{emoji.image_filename}"
      "<img alt='#{emoji.name}' src='#{image_path}' class='icon-emoji' />"
    end

    def css(file)
      options = { rel: 'stylesheet', type: 'text/css' }
      self.tag(:link, { href: "/css/#{file}.css" }.update(options))
    end
  end
end