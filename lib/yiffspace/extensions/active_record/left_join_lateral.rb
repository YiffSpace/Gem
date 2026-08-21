# frozen_string_literal: true

module YiffSpace
  module Extensions
    module ActiveRecord
      module LeftJoinLateral
        def left_join_lateral(relation, on: nil)
          raise(ArgumentError, "The method .left_join_lateral() must contain arguments.") if relation.nil?

          relation = relation.arel if relation.respond_to?(:arel)
          spawn.left_join_lateral!(relation, on: on)
        end

        def left_join_lateral!(relation, on: nil) # :nodoc:
          manager = klass.arel_table.left_join_lateral(relation)
          manager.on(on) if on

          self.joins_values |= [manager.join_sources.first]
          self
        end
      end
    end
  end
end
