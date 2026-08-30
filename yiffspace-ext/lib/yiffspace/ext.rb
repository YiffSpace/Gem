# frozen_string_literal: true

require("zeitwerk")

module YiffSpace
  module Ext
  end
end

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.ignore("#{__dir__}/core_ext")
loader.setup
