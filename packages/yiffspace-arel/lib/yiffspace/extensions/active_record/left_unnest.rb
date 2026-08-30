# frozen_string_literal: true

module YiffSpace
  module Extensions
    module ActiveRecord
      module LeftUnnest
        def left_unnest(column, as: column.singularize)
          raise(ArgumentError, "The method .left_unnest() must contain arguments.") if column.nil?

          spawn.unnest(column, as: as, type: :left_join_lateral)
        end
      end
    end
  end
end
