# frozen_string_literal: true
require 'securerandom'
require 'pathname'
require 'fileutils'
# Provide a convenient temporary folder deleted
# once no longer needed.
class TempFolder
  class << self
    attr_reader :default_root

    def host_process(root = default_root)
      raise 'Missing block' unless block_given?
      folder = next_temp_folder(root)
      Dir.chdir(folder) { yield }
    ensure
      FileUtils.rm_rf(folder) if Dir.exist?(folder)
    end

    def default_root=(pathname_or_str)
      @default_root = Pathname.new(pathname_or_str).realpath.freeze
    end

    private

    def next_temp_folder(root)
      tmp_dir = root + SecureRandom.uuid
      tmp_dir = root + SecureRandom.uuid while File.exist?(tmp_dir)
      FileUtils.mkdir_p(tmp_dir).first
    end
  end

  self.default_root = '.'
end
