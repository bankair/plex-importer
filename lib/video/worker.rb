# frozen_string_literal: true
$LOAD_PATH.unshift('lib')

require 'sidekiq'
require 'fileutils'
require 'temp_folder'
require 'video/importer'
require 'video/importer/youtube'
require 'video/storage'
require 'video/storage/file'

class Video
  # Worker in charge of draining and saving videos
  class Worker
    include Sidekiq::Worker

    ROOT_KEY = 'VIDEO_STORAGE_LOCAL_ROOT'
    ROOT = ENV[ROOT_KEY] || raise("Missing env var #{ROOT_KEY}")
    STORAGE = Video::Storage::File.new(ROOT).as_a(Video::Storage)

    def perform(url)
      puts "Trying to retrieve url #{url}"
      TempFolder.host_process('./tmp') do
        STORAGE.process(Video.new(importer_for(url).process(url)))
      end
    end

    private

    IMPORTERS = {
      youtube: Video::Importer::Youtube.new.as_a(Video::Importer)
    }.freeze

    def importer_for(url)
      # Quite lame, but that's a start
      IMPORTERS.each { |token, importer| return importer if url.index(token) }
      raise 'Importer not found'
    end
  end
end
