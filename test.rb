ENV['RACK_ENV'] = 'test'

Bundler.require(:default, :test)

require 'json'
require 'minitest/autorun'
require_relative 'server'

describe "site" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "has valid JSON" do
    contents = File.read('views/index.json')
    JSON.parse(contents) # shouldn't raise an exception
  end

  it "responds with a 200 on the homepage" do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?("Aidan Feldman")
  end

  it "responds with a 200 on the resume" do
    get '/resume'
    assert last_response.ok?
    assert last_response.body.include?("Aidan Feldman")
  end
end
