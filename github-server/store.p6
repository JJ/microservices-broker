#!/usr/bin/env perl6

use v6;

use Cro::HTTP::Server;
use Cro::HTTP::Router;

my %changes;
my $application = route {
    put -> $sha1, $file-name, Int $adds, Int $deletes {
        %changes{$sha1} = { file => $file-name, adds => $adds, deletes => $deletes };
        say "Nuevo recurso → ", %changes{$sha1}.perl;
        created $sha1, 'application/json', { status => "OK" }; #Responde con un OK
    }
}

# Crea el objeto que sirve
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
