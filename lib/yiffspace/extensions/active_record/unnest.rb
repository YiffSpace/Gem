# frozen_string_literal: true

module YiffSpace
  module Extensions
    module ActiveRecord
      module Unnest
        def unnest(column, as: column.singularize, type: :left_join_lateral)
          raise(ArgumentError, "The method .unnest() must contain arguments.") if column.nil?

          spawn.unnest!(column, as, type)
        end

        def unnest!(column, name, type) # :nodoc:
          function = ::Arel::Nodes::NamedFunction.new("unnest", [klass.arel_table[column]]).as(name)
          spawn.send("#{type}!", function, **({ on: ::Arel.sql("TRUE") } if type == :left_join_lateral))
        end
      end
    end
  end
end
