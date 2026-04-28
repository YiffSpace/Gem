# frozen_string_literal: true

require_relative("../../extensions/enumerable/parallel")

module Enumerable
  include(YiffSpace::Extensions::Enumerable::Parallel)
end
