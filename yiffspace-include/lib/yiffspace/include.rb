# frozen_string_literal: true

# Deprecated global-constant aliases (TableBuilder, UserLike, QueryBuilder, etc) for the classes
# that now live under YiffSpace::*. Nothing is loaded just by requiring "yiffspace/include" -
# require "yiffspace/include/all" for every alias this gem knows about, or an individual one
# (e.g. "yiffspace/include/table_builder"). Each alias only loads if the gem that owns the real
# class is actually installed - see lib/yiffspace/include/*.rb.

require_relative("include/version")

module YiffSpace
  module Include
  end
end
