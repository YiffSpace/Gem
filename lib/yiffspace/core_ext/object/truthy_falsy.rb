# frozen_string_literal: true

require_relative("../../extensions/object/truthy_falsy")

class Object
  include(YiffSpace::Extensions::Object::TruthyFalsy)
end
