# frozen_string_literal: true

require("zeitwerk")

module YiffSpace
  module Config
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.setup
