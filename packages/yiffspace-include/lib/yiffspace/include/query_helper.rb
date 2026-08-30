# frozen_string_literal: true

begin
  require("yiffspace/search")
  QueryHelper = YiffSpace::Search::QueryHelper
rescue LoadError
  nil
end
