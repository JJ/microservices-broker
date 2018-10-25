#!/usr/bin/env ruby

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'net/http'
require 'pp'

set :port, 31415

# Descarga las diferencias hechas para un push
post '/' do
  push = JSON.parse(request.body.read)
  piezas = push["compare"].split("/")
  api_url = "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}"
  diff = Net::HTTP.get(URI("https://api.github.com#{api_url}"))
  puts diff.is_a?(Array)
  diff_data = JSON.parse(diff)
end
