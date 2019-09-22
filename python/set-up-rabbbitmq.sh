#!/bin/bash

sudo rabbitmqctl add_user iv $RMQ_PASS        # Cambiar a una clave determinada
sudo rabbitmqctl add_vhost iv                                # Host virtual que vamos a usar
sudo rabbitmqctl set_permissions -p iv iv ".q*" ".*" ".*" # Permisos del usuario sobre el vhost
sudo rabbitmqctl set_user_tags iv management                 # Calificción del usuario nuevo.
