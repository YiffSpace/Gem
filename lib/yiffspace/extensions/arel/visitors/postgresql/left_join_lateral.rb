# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Arel
      module Visitors
        module PostgreSQL
          module LeftJoinLateral
            # noinspection RubyInstanceMethodNamingConvention
            def visit_YiffSpace_Extensions_Arel_Nodes_LeftJoinLateral(o, collector)
              collector << "LEFT JOIN LATERAL "
              visit(o.left, collector)
              return unless o.right

              collector << " ON "
              visit(o.right.expr, collector)
            end
          end
        end
      end
    end
  end
end
