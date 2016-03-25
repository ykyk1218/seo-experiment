require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sass'
require 'coffee-script'
require 'logger'

$stdout.sync = true
logger = Logger.new('sinatra.log')

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  # routingの設定
  get '/' do
    slim :index
  end

  get '/scroll' do
    slim :scroll 
  end

  get '/kizashi' do
    require 'rexml/document'
    require 'net/http'

    #url = "http://b.hatena.ne.jp/entry/json/?url=" + URI.escape("http://anond.hatelabo.jp/20160215171759")
    url = "http://b.hatena.ne.jp/entry/json/?url=" + CGI.escape("http://anond.hatelabo.jp/20160215171759")
    uri = URI.parse(url)

    @xml = Net::HTTP.get(uri)
    @xml = @xml.encode("UTF-8")

    slim :kizashi, :layout=>:ajax_layout
  end
end
