# frozen_string_literal: true

begin
  require("yiffspace/core")
  ParseValue = YiffSpace::Utils::ParseValue
rescue LoadError
  nil
end
