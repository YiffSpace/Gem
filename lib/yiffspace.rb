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
loader.setup
