# frozen_string_literal: true
require 'video/storage'
require 'pathname'
require 'fileutils'

class Video
  class Storage
    # Local file video storage
    class File
      def initialize(root_path)
        @root_path = Pathname.new(root_path)
        raise "#{@root_path} is not a directory" unless @root_path.directory?
      end

      def process(video)
        FileUtils.mv(video.path, @root_path)
      end
    end
  end
end
