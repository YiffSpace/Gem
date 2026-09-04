# frozen_string_literal: true

require("rails")

module YiffSpace
  module Fixers
    # No app/ of its own - this exists so Rails::Engine's default rake_tasks block picks up
    # lib/tasks/fixes.rake (config.root anchors where it looks for lib/tasks/**/*.rake).
    class Engine < ::Rails::Engine
      config.root = File.expand_path("../../..", __dir__)

      initializer("yiffspace.fixers.requires_fix") do
        ActiveRecord::Migration.include(YiffSpace::Fixers::RequiresFix)
      end
    end
  end
end
