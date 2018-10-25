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
  res = Net::HTTP.get_response(URI("https://api.github.com#{api_url}"))
  pp( res.body )
  diff_data = JSON.parse(res.body)
end
