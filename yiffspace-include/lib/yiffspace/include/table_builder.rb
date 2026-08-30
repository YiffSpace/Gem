# frozen_string_literal: true

begin
  require("yiffspace/tables")
  TableBuilder = YiffSpace::Tables::Builder
rescue LoadError
  nil
end
