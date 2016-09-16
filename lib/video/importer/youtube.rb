# frozen_string_literal: true
require 'video/importer'

class Video
  class Importer
    # Use youtube-dl to fetch a video
    class Youtube
      class ImportError < StandardError; end

      def process(url)
        output = `youtube-dl '#{url}'`
        candidates = Dir['*']
        raise ImportError, output if candidates.size != 1
        candidates.first
      end

      quacks_like_a! Video::Importer
    end
  end
end
