# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Arel
      module Visitors
        class Postgresql
          # noinspection RubyInstanceMethodNamingConvention
          def visit_Arel_Nodes_CrossJoinLateral(o, collector)
            collector << "CROSS JOIN LATERAL "
            visit(o.left, collector)
          end

          # noinspection RubyInstanceMethodNamingConvention
          def visit_Arel_Nodes_LeftJoinLateral(o, collector)
            collector << "LEFT JOIN LATERAL "
            visit(o.left, collector)
            if o.right
              collector << " ON "
              visit(o.right.expr, collector)
            end
          end
        end
      end
    end
  end
end
