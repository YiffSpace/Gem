# frozen_string_literal: true

begin
  require("yiffspace/core")
  Helpers = YiffSpace::Utils::Helpers
rescue LoadError
  nil
end
