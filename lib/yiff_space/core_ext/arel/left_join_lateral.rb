# frozen_string_literal: true

require_relative("../../extensions/arel/nodes/left_join_lateral")
require_relative("../../extensions/arel/visitors/postgresql/left_join_lateral")
require_relative("../../extensions/arel/table/left_join_lateral")

module Arel
  module Nodes
    LeftJoinLateral = YiffSpace::Extensions::Arel::Nodes::LeftJoinLateral
  end

  module Visitors
    class PostgreSQL
      include(YiffSpace::Extensions::Arel::Visitors::PostgreSQL::LeftJoinLateral)
    end
  end

  class Table
    include(YiffSpace::Extensions::Arel::Table::LeftJoinLateral)
  end
end
