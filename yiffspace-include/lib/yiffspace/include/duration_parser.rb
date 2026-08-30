# frozen_string_literal: true

begin
  require("yiffspace/core")
  DurationParser = YiffSpace::Utils::DurationParser
rescue LoadError
  nil
end
