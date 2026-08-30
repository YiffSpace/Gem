# frozen_string_literal: true

begin
  require("yiffspace/core")
  OpenHash = YiffSpace::Utils::OpenHash
rescue LoadError
  nil
end
