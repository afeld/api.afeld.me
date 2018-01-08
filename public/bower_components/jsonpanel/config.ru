#!/usr/bin/env rackup
#\ -E deployment

# http://blog.samsonis.me/2010/02/rubys-python-simplehttpserver/

use Rack::ContentLength

app = Rack::Directory.new Dir.pwd
run app
