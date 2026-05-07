# frozen_string_literal: true

module YiffSpace
end

require("zeitwerk")

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect({ "postgresql" => "PostgreSQL", "yiffspace" => "YiffSpace" })
loader.ignore("#{__dir__}/yiffspace/core_ext")
loader.setup
