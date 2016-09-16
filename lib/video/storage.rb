# frozen_string_literal: true
require 'duck_enforcer'
class Video
  # Interface-ish thingy for Video Storages
  class Storage < DuckEnforcer
    implement :process
  end
end
