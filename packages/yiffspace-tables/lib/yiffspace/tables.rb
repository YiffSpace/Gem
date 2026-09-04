# frozen_string_literal: true

require("yiffspace/core")
require("zeitwerk")

module YiffSpace
  module Tables
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.setup
