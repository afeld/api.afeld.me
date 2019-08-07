# frozen_string_literal: true

require 'json'
require 'rdiscount'
require 'sinatra/asset_pipeline'
require 'sinatra/respond_with'
require 'sprockets-helpers'
require 'active_support/all'
require_relative './lib/html_helpers'
require_relative './lib/skill_helpers'
require_relative './lib/time_helpers'

if development?
  require 'sinatra/reloader'
  enable :reloader
elsif test?
  enable :show_exceptions
end

enable :logging
register Sinatra::AssetPipeline

configure do
  set :assets_css_compressor, :sass
  set :assets_precompile, %w[*.css]
end

path = File.expand_path('views/index.json', __dir__)
PROFILE_STR = File.read(path).freeze
PROFILE_HSH = JSON.parse(PROFILE_STR).to_dot.freeze
JOBS = (PROFILE_HSH.experience.coding + PROFILE_HSH.experience.teaching).sort_by(&:start_date).reverse

# https://banisterfiend.wordpress.com/2009/10/02/wtf-infinite-ranges-in-ruby/
INF = 1.0 / 0.0

helpers do
  include ActiveSupport::NumberHelper
  include Sprockets::Helpers
  include HtmlHelpers
  include SkillHelpers
  include TimeHelpers
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

get '/rider' do
  markdown :rider, layout_engine: :erb, layout: :rider, layout_options: { views: 'views/layouts' }
end
