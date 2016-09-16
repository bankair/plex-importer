# app.rb
#
$LOAD_PATH.unshift('lib')

require 'sinatra'
require_relative './lib/video/worker'

get('/') { 'Plex Importer, bitch !' }

get '/import' do
  uri = params.fetch('uri')
  VideoWorker.perform_async(uri)
  redirect to(uri)
end
