# frozen_string_literal: true

require("zeitwerk")

module YiffSpace
  module Arel
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.inflector.inflect({ "postgresql" => "PostgreSQL" })
loader.ignore("#{__dir__}/core_ext")
loader.setup
