# frozen_string_literal: true

module YiffSpace
  module Utils
    class SetEnvConstraint
      attr_reader(:key, :value)

      def initialize(key, value)
        @key   = key.to_s
        @value = value
      end

      def matches?(request)
        request.env[key.to_s] = value
      end
    end
  end
end
