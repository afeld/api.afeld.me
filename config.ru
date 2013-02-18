require 'rubygems'
require 'bundler'

Bundler.require

require 'sass/plugin/rack'
require './server'

run Sinatra::Application
