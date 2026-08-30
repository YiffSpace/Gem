# frozen_string_literal: true

begin
  require("yiffspace/core")
  ActiveRecordExtensions = YiffSpace::Concerns::ActiveRecordExtensions
rescue LoadError
  nil
end
