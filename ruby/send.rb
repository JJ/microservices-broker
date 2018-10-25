#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

loop do
  rander = rand(10)
  channel.default_exchange.publish("Hello #{rander}", routing_key: queue.name)
  puts " [x] Sent 'Hello #{rander}'"
end

connection.close
