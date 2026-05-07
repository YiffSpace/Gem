# frozen_string_literal: true

require("active_support/core_ext/module/attribute_accessors")

module YiffSpace
  module Extensions
    module Enumerable
      module Parallel
        mattr_accessor(:usable)
        # Like `#each`, but perform the block on each item in parallel. Note that items aren't processed in order, so things
        # like `parallel_each.map` that rely on ordering won't work.
        def parallel_each(executor = :io, &)
          return enum_for(:parallel_each, executor) unless block_given?

          parallel_map(executor, &)
          self
        end

        # Like `#map`, but in parallel.
        def parallel_map(executor = :io, &)
          return enum_for(:parallel_map, executor) unless block_given?

          promises = map do |item|
            Concurrent::Promises.future_on(executor, item, &)
          end

          Concurrent::Promises.zip_futures_on(executor, *promises).value!
        end
      end
    end
  end
end

begin
  require("concurrent-ruby")
  YiffSpace::Extensions::Enumerable::Parallel.usable = true
rescue LoadError
  YiffSpace::Extensions::Enumerable::Parallel.usable = false
end
