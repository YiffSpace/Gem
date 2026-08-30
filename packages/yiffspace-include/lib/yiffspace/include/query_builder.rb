# frozen_string_literal: true

begin
  require("yiffspace/search")
  QueryBuilder = YiffSpace::Search::QueryBuilder
rescue LoadError
  nil
end
