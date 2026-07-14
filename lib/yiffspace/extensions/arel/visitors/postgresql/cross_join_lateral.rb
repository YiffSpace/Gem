# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Arel
      module Visitors
        module PostgreSQL
          module CrossJoinLateral
            # noinspection RubyInstanceMethodNamingConvention
            def visit_YiffSpace_Extensions_Arel_Nodes_CrossJoinLateral(o, collector)
              collector << "CROSS JOIN LATERAL "
              visit(o.left, collector)
            end
          end
        end
      end
    end
  end
end
