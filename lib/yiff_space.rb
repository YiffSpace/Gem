# frozen_string_literal: true

require("zeitwerk")

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/yiff_space/core_ext")
loader.setup

require("yiff_space/auth/engine") if defined?(Rails::Engine)

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
