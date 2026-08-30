# frozen_string_literal: true

begin
  require("yiffspace/core")
  Cache = YiffSpace::Utils::Cache
rescue LoadError
  nil
end
