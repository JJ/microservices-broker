#!/usr/bin/env ruby

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'

set :port, 31415

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "Me enviaron este JSON: #{push.inspect}"
end
