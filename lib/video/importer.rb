# frozen_string_literal: true
require 'duck_enforcer'
class Video
  # Interface-ish thingy for video importers
  class Importer < DuckEnforcer
    implement :process
  end
end
