# frozen_string_literal: true

begin
  require("yiffspace/core")
  AttributeMatchers = YiffSpace::Concerns::AttributeMatchers
rescue LoadError
  nil
end
