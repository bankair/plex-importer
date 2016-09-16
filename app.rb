# app.rb

require 'sinatra'
require_relative './lib/video/worker'

get('/') { 'Plex Importer, bitch !' }

get '/import' do
  uri = params.fetch('uri')
  Video::Worker.perform_async(uri)
  redirect to(uri)
end
