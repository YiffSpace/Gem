# frozen_string_literal: true

begin
  require("yiffspace/core")
  HasBitFlags = YiffSpace::Concerns::HasBitFlags
rescue LoadError
  nil
end
