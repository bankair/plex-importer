require 'sidekiq'
require 'securerandom'
require 'fileutils'

class VideoWorker
  include Sidekiq::Worker

  def perform(encoded_url)
    puts "Trying to retrieve url #{encoded_url}"
    tmp_dir = SecureRandom.uuid
    Dir.mkdir(tmp_dir)
    Dir.chdir(tmp_dir) do
      puts `youtube-dl #{encoded_url}`
      candidates = Dir['*']
      if candidates.size != 1
        puts "Could not select candidates in #{candidates.inspect}"
      else
        FileUtils.mv(candidates.first, '/var/lib/plexmediaserver/Test/')
      end
    end
    FileUtils.rm_rf(tmp_dir)
  end
end
