#!/usr/bin/env ruby
# coding: utf-8

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'

set :port, 31415

post '/' do
  push = JSON.parse(request.body.read)
  commit_sha = push.commit.sha
  puts "Commit → #{commit_sha}"
end


