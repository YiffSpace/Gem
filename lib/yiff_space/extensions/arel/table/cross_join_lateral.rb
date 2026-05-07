# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Arel
      module Table
        module CrossJoinLateral
          def cross_join_lateral(relation)
            join(relation, ::Arel::Nodes::CrossJoinLateral)
          end
        end
      end
    end
  end
end
