require 'sinatra/respond_with'
require 'json'

if development?
  require 'sinatra/reloader'
  enable :reloader
end

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
# workaround for https://github.com/adsteel/hash_dot/issues/18
Hash.use_dot_syntax = true
PROFILE_HSH = JSON.parse(PROFILE_STR).freeze
JOBS = (PROFILE_HSH.employment.coding + PROFILE_HSH.employment.teaching).sort_by(&:start_date).reverse

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

  def date(date_str)
    if date_str.scan(/-/).size == 1
      # month only
      Date.strptime(date_str, '%Y-%m').strftime('%b %Y')
    else
      Date.parse(date_str).strftime('%b %-m, %Y')
    end
  end

  def date_range(obj)
    start_date = date(obj.start_date)
    end_date = obj['end_date'] ? date(obj.end_date) : 'present'
    "#{start_date} — #{end_date}"
  end

  def url(url_str)
    url_str.sub(/^https?:\/\/(www\.)?/, '')
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

get '/resume' do
  erb :resume
end
