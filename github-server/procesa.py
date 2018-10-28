#!/usr/bin/env python

import pika
import urllib.request
import json
import requests

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
print( "Connected" )

channel.queue_declare(queue="hook")
print( "Channel open" )

# Step #5
def descarga(channel, method, properties, body):
    """Called when we receive a message from RabbitMQ"""
    url = body.decode()
    print(" [x] Recibido %r" % url )
    piezas = url.split("/")
    api_url = "https://api.github.com/repos/%s/%s/compare/%s"%(piezas[2],piezas[3],piezas[5])
    with urllib.request.urlopen(api_url) as response:
        data_json = response.read()
        data = json.loads(data_json)
        for f in data['files']:
            file_data = { "sha1": f['sha'],
                         "file-name": f['filename'],
                         "adds": f['additions'],
                         "deletes": f['deletions']
            }
            print(json.dumps(file_data))
            response = requests.put("http://localhost:2314",data=json.dumps(file_data))
            print(response)

channel.basic_consume(descarga,
                      queue='hook',
                      no_ack=True)

print( ' [*] Esperando mensajes. Interrumpe con ctrl-C' )
channel.start_consuming()
