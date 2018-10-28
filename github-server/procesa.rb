#!/usr/bin/env ruby

require 'bunny'
require 'json'

connection = Bunny.new(automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue('hello')


begin
  puts ' [*] Esperando mensajes. Interrumpe con ctrl-C'
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    puts " [x] Recibido #{body}"
  end
  
rescue Interrupt => _
  connection.close

  exit(0)
end


