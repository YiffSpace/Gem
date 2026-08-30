# frozen_string_literal: true

require_relative("../../extensions/arel/nodes/cross_join_lateral")
require_relative("../../extensions/arel/visitors/postgresql/cross_join_lateral")
require_relative("../../extensions/arel/table/cross_join_lateral")

module Arel
  module Nodes
    CrossJoinLateral = YiffSpace::Extensions::Arel::Nodes::CrossJoinLateral
  end

  module Visitors
    class PostgreSQL
      include(YiffSpace::Extensions::Arel::Visitors::PostgreSQL::CrossJoinLateral)
    end
  end

  class Table
    include(YiffSpace::Extensions::Arel::Table::CrossJoinLateral)
  end
end
