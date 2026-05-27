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

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect({ "postgresql" => "PostgreSQL", "yiffspace" => "YiffSpace", "query_dsl" => "QueryDSL" })
loader.ignore("#{__dir__}/yiffspace/core_ext")
loader.ignore("#{__dir__}/yiffspace/include")
loader.setup
