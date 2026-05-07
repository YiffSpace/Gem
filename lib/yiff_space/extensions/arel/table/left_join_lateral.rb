# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Arel
      module Table
        module LeftJoinLateral
          def left_join_lateral(relation)
            join(relation, ::Arel::Nodes::LeftJoinLateral)
          end
        end
      end
    end
  end
end
