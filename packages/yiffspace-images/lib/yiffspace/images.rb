# frozen_string_literal: true

require("yiffspace/core")
require("zeitwerk")

module YiffSpace
  module Images
  end

  class Configuration
    def images
      @images ||= Images::Configuration.new
    end
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.ignore("#{__dir__}/images/engine.rb")
loader.setup

# Require the engine eagerly so it registers with Rails before the host app's
# active_support.initialize_per_engine_zeitwerk_loaders initializer runs.
require_relative("images/engine") if defined?(Rails)
