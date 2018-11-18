# Servidor de hooks de GitHub de test



## Servidor de hooks en tres microservicios

Primero, habrá que asegurarse de que RabbitMQ está andando.

Instala todo con

    make install
    
(tendrás que tener previamente instalado Ruby 2.x, Python 3.x y Perl
6)

Instala foreman si no está instalado con 

    gem install foreman
    
Y echa a andar los tres servicios con

    foreman start
    

## Servidor de hooks en un solo fichero
Instalar con 

    bundle install
    
A continuación, crear la base de datos con

    sqlite3 files.db < table.sql
    
Arranca el servidor monolítico de hooks con

    ./server.rb

Y a continuación, exponlo en la Internet con

    ngrok http 31415
    
(O el puerto en el que se haya arrancado)

Se pueden ver los cambios en la base de datos con

    sqlite3 files.db
    
y

    select * from filechanges;
    
## Una vez andando

Se puede crear una URL pública con:

    ngrok http 31415
    
Y arrancar un logger con

    fluentd -c fluentd.conf
