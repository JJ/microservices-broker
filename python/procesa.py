from celery import Celery
import os

app = Celery('procesa', broker='amqp://iv:{}@localhost/iv'.format(os.environ.get('RMQ_PASS')))

@app.task
def descarga(url):
    print("Descargando {}".format(url))
