require 'sinatra/base'
require 'sinatra/reloader'
require 'slim'
require 'sass'
require 'coffee-script'
require 'logger'
require 'json'

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

  get '/b_hatena' do
    require 'rexml/document'
    require 'net/http'

    #url = "http://b.hatena.ne.jp/entry/json/?url=" + URI.escape("http://anond.hatelabo.jp/20160215171759")
    url = "http://b.hatena.ne.jp/entry/json/?url=" + CGI.escape("http://anond.hatelabo.jp/20160215171759")
    uri = URI.parse(url)

    userAgent = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)'
    response = nil
    Net::HTTP.start(uri.host) do |http|
      response = http.get(uri, {'User-Agent' => userAgent})
    end
    @json = response.body
    json_data = JSON.load(response.body)
    page = params[:page]
    page_view_count = 10
    result_data = []
    roop_count = 0
    json_data['bookmarks'].each.with_index((page.to_i-1)*10) do |bookmark|
      result_data.push(bookmark)
      roop_count = roop_count + 1
      if roop_count >= page_view_count
        break
      end
    end
    #@xml = Net::HTTP.get(uri)

    content_type :json
    #slim :b_hatena, :layout=>:ajax_layout
    result_data.to_json
  end
end
