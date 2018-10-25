#!/usr/bin/env ruby

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'httparty'
require 'pp'
require 'bunny'

connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

set :port, 31415

# Descarga las diferencias hechas para un push
post '/' do
  push = JSON.parse(request.body.read)
  piezas = push["compare"].split("/")
  channel.default_exchange.publish( "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}", routing_key: queue.name)
end
