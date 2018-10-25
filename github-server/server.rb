#!/usr/bin/env ruby
# coding: utf-8

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'net/http'

set :port, 31415

# Responde directamente desde el raíz
post '/' do
  push = JSON.parse(request.body.read)
  puts "Commit → #{push}"
  piezas = push["compare"].split("/")
  api_url = "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}"
  puts api_url
  diff = Net::HTTP.get(URI("https://api.github.com#{api_url}"))
  puts diff
end
