#!/usr/bin/env python

import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
print( "Connected" )

channel.queue_declare(queue="hook")
print( "Channel open" )
    


# Step #5
def descarga(channel, method, properties, body):
    """Called when we receive a message from RabbitMQ"""
    print(" [ ] Recibido %r" % body )

channel.basic_consume(descarga,
                      queue='hook',
                      no_ack=True)

print( ' [*] Esperando mensajes. Interrumpe con ctrl-C' )
channel.start_consuming()
