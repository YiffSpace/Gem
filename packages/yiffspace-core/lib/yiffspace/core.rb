# frozen_string_literal: true

require("zeitwerk")
require("active_support/all")
require("active_support/core_ext/object/blank")

module YiffSpace
  module Core
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
    end
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.ignore("#{__dir__}/engine.rb")
loader.setup

# Require the engine eagerly so it registers with Rails before the host app's
# active_support.initialize_per_engine_zeitwerk_loaders initializer runs. Without this,
# the engine is only loaded lazily (after Zeitwerk setup) and its app/controllers
# path is never added to the app's autoload roots.
require_relative("engine") if defined?(Rails)
