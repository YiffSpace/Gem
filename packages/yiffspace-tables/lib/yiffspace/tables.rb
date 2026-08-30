# frozen_string_literal: true

require("yiffspace/core")
require("zeitwerk")

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.setup
