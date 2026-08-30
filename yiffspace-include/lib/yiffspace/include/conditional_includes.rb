# frozen_string_literal: true

begin
  require("yiffspace/core")
  ConditionalIncludes = YiffSpace::Concerns::ConditionalIncludes
rescue LoadError
  nil
end
