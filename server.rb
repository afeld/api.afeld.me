require 'sinatra'
require 'sinatra/respond_to'

Sinatra::Application.register Sinatra::RespondTo
enable :logging

configure do
  # copied from https://github.com/chriseppstein/compass/wiki/Sinatra-Integration
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, format: :html5
  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
end

PROFILE_STR = File.read('./views/index.json').freeze


get '/stylesheets/application' do
  scss :application
end

get %r{/(index)?} do
  respond_to do |wants|
    wants.html { erb :index }      # => views/posts.html.haml, also sets content_type to text/html
    wants.json { PROFILE_STR }       # => views/posts.rss.haml, also sets content_type to application/rss+xml
  end
end
