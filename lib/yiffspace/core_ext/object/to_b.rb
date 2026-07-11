# frozen_string_literal: true

require_relative("../../extensions/object/to_b")

class Object
  include(YiffSpace::Extensions::Object::ToB)
end
