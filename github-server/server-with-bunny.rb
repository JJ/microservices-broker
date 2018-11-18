#!/usr/bin/env ruby

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'bunny'
require 'etcdv3'

# Connects to RabbitMQ
connection = Bunny.new(automatically_recover: false)
connection.start

# Connects to etcd
client = Etcdv3.new(endpoints: 'http://127.0.0.1:2379')

queue_name = client.get('queue_name').kvs.first.value
puts "Queue name #{queue_name}"

channel = connection.create_channel
queue = channel.queue(queue_name) # Cola que configurar

set :port, 31415              # Puerto que configurar

# Descarga las diferencias hechas para un push
post '/' do
  push = JSON.parse(request.body.read)
  piezas = push["compare"].split("/")
  channel.default_exchange.publish( "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}", routing_key: queue.name)
end
