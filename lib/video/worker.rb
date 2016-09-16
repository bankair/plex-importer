# frozen_string_literal: true
$LOAD_PATH.unshift('lib')

require 'sidekiq'
require 'fileutils'
require 'temp_folder'

class Video
  # Worker in charge of draining and saving videos
  class Worker
    include Sidekiq::Worker
    class << self
      def storage
        @storage ||= storage_impl
      end

      def importers
        @importers ||= importers_impl
      end

      private

      def storage_impl
        require 'video/storage'
        require 'video/storage/file'
        Video::Storage::File.new(ROOT).as_a(Video::Storage).freeze
      end

      def importers_impl
        require 'video/importer'
        require 'video/importer/youtube'
        {
          youtube: Video::Importer::Youtube.new.as_a(Video::Importer)
        }.freeze
      end
    end

    ROOT_KEY = 'VIDEO_STORAGE_LOCAL_ROOT'
    ROOT = ENV[ROOT_KEY] || raise("Missing env var #{ROOT_KEY}")

    def perform(url)
      puts "Trying to retrieve url #{url}"
      TempFolder.host_process('./tmp') do
        self.class.storage.process(Video.new(importer_for(url).process(url)))
      end
    end

    private

    def importer_for(url)
      # Quite lame, but that's a start
      self.class.importers.each do |token, importer|
        return importer if url.index(token)
      end
      raise 'Importer not found'
    end
  end
end
