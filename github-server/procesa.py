#!/usr/bin/env python

import pika
import json
import requests
import etcd3

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()
print( "Connected" )

etcd = etcd3.client()
hook_name = etcd.get("queue_name")
channel.queue_declare(queue=hook_name[0].decode('utf8'))
print( "Channel open" )

store_port = etcd.get("store_port")

# Se llama a esto
def descarga(channel, method, properties, body):
    """Called when we receive a message from RabbitMQ"""
    url = body.decode()
    print(" [x] Recibido %r" % url )
    piezas = url.split("/")
    api_url = "https://api.github.com/repos/%s/%s/compare/%s"%(piezas[2],piezas[3],piezas[5])
    response = requests.get(api_url)
    if (response.ok):
        data = response.json()
        for f in data['files']:
            file_data = { "sha1": f['sha'],
                         "file-name": f['filename'],
                         "adds": f['additions'],
                         "deletes": f['deletions']
            }
            print(json.dumps(file_data))
            response = requests.put("http://localhost:%s" % store_port,
                                    headers={"content-type": "application/json"},
                                    data=json.dumps(file_data))
            print(response)

channel.basic_consume(descarga,
                      queue='hook',
                      no_ack=True)

print( ' [*] Esperando mensajes. Interrumpe con ctrl-C' )
channel.start_consuming()
