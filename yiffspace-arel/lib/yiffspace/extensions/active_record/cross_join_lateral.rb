# frozen_string_literal: true

module YiffSpace
  module Extensions
    module ActiveRecord
      module CrossJoinLateral
        def cross_join_lateral(relation)
          raise(ArgumentError, "The method .cross_join_lateral() must contain arguments.") if relation.nil?

          relation = relation.arel if relation.respond_to?(:arel)
          spawn.cross_join_lateral!(relation)
        end

        def cross_join_lateral!(relation) # :nodoc:
          manager = klass.arel_table.cross_join_lateral(relation)

          self.joins_values |= [manager.join_sources.first]
          self
        end
      end
    end
  end
end
