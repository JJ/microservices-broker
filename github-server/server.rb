#!/usr/bin/env ruby

# De https://developer.github.com/webhooks/configuring/

require 'sinatra'
require 'json'
require 'httparty'
require 'pp'
require "sqlite3"

set :port, 31415
db = SQLite3::Database.new "files.db"


# Descarga las diferencias hechas para un push
post '/' do
  push = JSON.parse(request.body.read)
  piezas = push["compare"].split("/")
  api_url = "/repos/#{piezas[3]}/#{piezas[4]}/compare/#{piezas[6]}"
  res = HTTParty.get("https://api.github.com#{api_url}")
  res["files"].each do |file|
    pp(file)
    db.execute("insert into filechanges (sha1,filename,additions,deletions) VALUES (?,?,?,?)",
               [file["sha"], file["filename"],file["additions"], file["deletions"]])
  end
end
