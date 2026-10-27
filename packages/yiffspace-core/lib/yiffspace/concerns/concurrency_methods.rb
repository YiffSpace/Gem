# frozen_string_literal: true

module YiffSpace
  module Concerns
    module ConcurrencyMethods
      extend(ActiveSupport::Concern)

      class_methods do
        def parallel_find_each(**, &block)
          # XXX We may deadlock if a transaction is open; do a non-parallel each.
          return find_each(&block) if connection.transaction_open?

          find_in_batches(error_on_ignore: true, **) do |batch|
            # The pool threads are shared and never finish, so a connection leased on one (any plain
            # `connection` call) would be held forever, starving the rest. Return it after each record
            batch.parallel_each do |record|
              connection_pool.with_connection(prevent_permanent_checkout: true) { block.call(record) }
            end
          end
        end
      end
    end
  end
end
