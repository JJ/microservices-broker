#!/usr/bin/env ruby
# coding: utf-8

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'

set :port, 31415

# Responde directamente desde el raíz
post '/' do
  push = JSON.parse(request.body.read)
  puts "Commit → #{push}"
end
