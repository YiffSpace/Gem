# frozen_string_literal: true

require_relative("../../extensions/string/truthy_falsy")

class String
  include(YiffSpace::Extensions::String::TruthyFalsy)
end
