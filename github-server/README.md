# Servidor de hooks de GitHub de test

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
    
