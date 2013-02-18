require 'sinatra'
require 'sinatra/respond_to'

Sinatra::Application.register Sinatra::RespondTo
enable :logging

# use scss for stylesheets
configure :development do
  Sass::Plugin.options[:trace_selectors] = :true
  Sass::Plugin.options[:style] = :expanded
end
configure :production do
  Sass::Plugin.options[:style] = :compressed
end
use Sass::Plugin::Rack

PROFILE_STR = File.read('./views/index.json').freeze

get %r{/(index)?} do
  respond_to do |wants|
    wants.html { erb :index }      # => views/posts.html.haml, also sets content_type to text/html
    wants.json { PROFILE_STR }       # => views/posts.rss.haml, also sets content_type to application/rss+xml
  end
end
