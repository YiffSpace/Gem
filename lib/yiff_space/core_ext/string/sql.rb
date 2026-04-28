# frozen_string_literal: true

require_relative("../../extensions/string/sql")

class String
  include(YiffSpace::Extensions::String::Sql)
end
