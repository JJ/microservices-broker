#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'pp'

diff = Net::HTTP.get(URI("https://api.github.com/repos/JJ/microservices-broker/compare/69ecc2394ba2...bf0cad05008c"))
puts diff.class
pp(JSON.parse(diff))

