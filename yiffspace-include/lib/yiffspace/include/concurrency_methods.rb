# frozen_string_literal: true

begin
  require("yiffspace/core")
  ConcurrencyMethods = YiffSpace::Concerns::ConcurrencyMethods
rescue LoadError
  nil
end
