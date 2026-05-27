# frozen_string_literal: true

module YiffSpace
  module Utils
    module Helpers
      module_function

      def method_missing(name, *, &)
        target.send(name, *, &)
      end

      def respond_to_missing?(...)
        target.respond_to?(...)
      end

      private

      # Lazily resolved so ApplicationController is not referenced at load time.
      def target
        ApplicationController.helpers
      end
    end
  end
end
