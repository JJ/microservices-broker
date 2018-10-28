from celery import Celery

app = Celery('procesa', broker='pyamqp://guest@localhost//')

@app.task
def descarga(url):
    print("Descargando #{url}")
