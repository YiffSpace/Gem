# frozen_string_literal: true

require_relative("../../extensions/string/to_b")

class String
  include(YiffSpace::Extensions::String::ToB)
end
