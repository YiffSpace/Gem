# frozen_string_literal: true

require("yiffspace/core")
require("yiffspace/ext")
require("yiffspace/user")
require("zeitwerk")

module YiffSpace
  module Search
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.inflector.inflect({ "query_dsl" => "QueryDSL" })
loader.setup
