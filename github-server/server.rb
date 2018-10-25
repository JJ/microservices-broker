#!/usr/bin/env ruby
# coding: utf-8

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'net/http'
require 'pp'


set :port, 31415

# Responde directamente desde el raíz
post '/' do
  push = JSON.parse(request.body.read)
  piezas = push["compare"].split("/")
  api_url = "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}"

  diff = Net::HTTP.get(URI("https://api.github.com#{api_url}"))
  pp(JSON.parse(diff))
end
