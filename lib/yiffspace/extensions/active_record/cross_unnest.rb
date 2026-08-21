# frozen_string_literal: true

module YiffSpace
  module Extensions
    module ActiveRecord
      module CrossUnnest
        def cross_unnest(column, as: column.singularize)
          raise(ArgumentError, "The method .cross_unnest() must contain arguments.") if column.nil?

          spawn.unnest(column, as: as, type: :cross_join_lateral)
        end
      end
    end
  end
end
