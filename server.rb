require 'sinatra'
require 'sinatra/respond_with'
require 'json'

enable :logging

configure do
  set :haml, format: :html5

  environment = Sprockets::Environment.new
  environment.append_path 'assets/stylesheets'
  # environment.append_path 'assets/javascripts'
  environment.css_compressor = :scss
  set :environment, environment
end

PROFILE_STR = File.read('./views/index.json').freeze
PROFILE_HSH = JSON.parse(PROFILE_STR).freeze

helpers do
  def to_html(val)
    case val
    when Array
      to_ul(val)
    when Hash
      to_dl(val)
    else
      val
    end
  end

  def to_dl(hash)
    out = "<dl>\n"
    hash.each do |key, val|
      out << "<dt>#{key}</dt>\n"
      dd = to_html(val)
      out << "<dd>#{dd}</dd>\n"
    end
    out << "</dl>\n"

    out
  end

  def to_ul(array)
    out = "<ul>\n"
    array.each do |item|
      li = to_html(item)
      out << "<li>#{li}</li>\n"
    end
    out << "</ul>\n"

    out
  end
end


get '/assets/*' do
  env['PATH_INFO'].sub!('/assets', '')
  settings.environment.call(env)
end

get %r{/(index)?} do
  respond_to do |wants|
    wants.html { erb :index }
    wants.json { PROFILE_STR }
  end
end

get '/index.json' do
  content_type 'application/json'
  PROFILE_STR
end

get '/meet' do
  erb :meet
end
