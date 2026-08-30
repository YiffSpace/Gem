# frozen_string_literal: true

begin
  require("yiffspace/core")
  AttributeMethods = YiffSpace::Concerns::AttributeMethods
rescue LoadError
  nil
end
