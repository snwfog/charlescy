require 'slim'
require 'eldr'
require 'eldr-rendering'

class Ohaider < Eldr::App
  Configuration = Struct.new *%i(views_dir engine)
  include Eldr::Rendering
  attr_accessor :configuration

  def initialize
    @configuration = Configuration.new File.join(__dir__, 'views'), 'slim'
  end

  get '/' do
    render 'index.slim'
  end

end
