#!/usr/bin/env ruby
# coding: utf-8

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'net/http'
require 'pp'

set :port, 31415

# Descarga las diferencias hechas para un push
post '/' do
  payload = request.body.read
  push = JSON.parse(payload)
  puts "\n\n→ " << push['compare']
end
