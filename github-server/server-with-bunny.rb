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
exchange_name = client.get('exchange_name').kvs.first.value


channel = connection.create_channel
queue = channel.queue(queue_name) # Cola que configurar
exchange = channel.fanout(exchange_name) # Intercambio que configurar

port_number = client.get('hook_port').kvs.first.value
set :port, port_number              # Puerto que configurar

# Descarga las diferencias hechas para un push
post '/' do
  push = JSON.parse(request.body.read)
  piezas = push["compare"].split("/")
  channel.default_exchange.publish( "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}", routing_key: queue.name)
  exchange.publish( "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}")
end
