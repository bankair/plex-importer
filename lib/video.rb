# frozen_string_literal: true
require 'video/worker'

# Model for a video file
class Video
  attr_reader :path

  def initialize(path)
    raise "Invalid value #{path.inspect}" if path.nil? || path == ''
    @path = Pathname.new(path)
    raise "Video #{path} not found" unless path.file?
  end
end
