require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sass'
require 'coffee-script'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  # routingの設定
  get '/' do
    slim :index
  end
end
