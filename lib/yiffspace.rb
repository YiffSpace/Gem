# frozen_string_literal: true

module YiffSpace
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield(config)
    end
  end
end

require("zeitwerk")
require("active_support/all")
require("active_support/core_ext/object/blank")

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect({ "postgresql" => "PostgreSQL", "yiffspace" => "YiffSpace", "query_dsl" => "QueryDSL" })
loader.ignore("#{__dir__}/yiffspace/core_ext")
loader.ignore("#{__dir__}/yiffspace/include")
loader.ignore("#{__dir__}/yiffspace/railtie.rb")
loader.ignore("#{__dir__}/yiffspace/auth/engine.rb")
loader.setup

# Require the auth engine eagerly so it registers with Rails before the host app's
# active_support.initialize_per_engine_zeitwerk_loaders initializer runs. Without this,
# the engine is only loaded during route drawing (after Zeitwerk setup) and its
# app/controllers path is never added to the app's autoload roots.
require_relative("yiffspace/auth/engine") if defined?(Rails)
