# frozen_string_literal: true

begin
  require("yiffspace/core")
  TraceLogger = YiffSpace::Utils::TraceLogger
rescue LoadError
  nil
end
