# frozen_string_literal: true

begin
  require("yiffspace/search")
  QueryDSL = YiffSpace::Search::QueryDSL
rescue LoadError
  nil
end
