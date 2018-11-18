#!/usr/bin/env perl6

use v6;

use Cro::HTTP::Server;
use Cro::HTTP::Router;

my %changes;
my $application = route {
    put ->  {
        request-body -> %json-object {
            %changes{%json-object<sha1>} = { file => %json-object<file-name>,
                                             adds => %json-object<adds>,
                                             deletes => %json-object<deletes> };
            say "Nuevo recurso → ", %changes{%json-object<sha1>}.perl;
            created %json-object<sha1>, 'application/json', { status => "OK" }; #Responde con un OK
        }
    }
}

# Crea el objeto que sirve con configuración en el puerto 2314
my Cro::Service $service = Cro::HTTP::Server.new(
    :host('localhost'), :port(2314), :$application
);

# Run it
$service.start;

# Cleanly shut down on Ctrl-C
react whenever signal(SIGINT) {
    $service.stop;
    exit;
}
