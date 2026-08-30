# frozen_string_literal: true

module YiffSpace
  module Concerns
    # methods to include into the user class for use with the like/resolvable classes
    module UserClassMethods
      extend(ActiveSupport::Concern)

      def resolvable(ip_addr = nil)
        YiffSpace.config.user_resolvable_class.new(self, ip_addr || "127.0.0.1")
      end

      def resolve
        self
      end

      def ==(other)
        return super if other.is_a?(YiffSpace.config.user_class)

        other.is_a?(YiffSpace.config.user_resolvable_class) && super(other.user)
      end

      def ===(other)
        other == YiffSpace.config.user_like_class || super
      end

      def is_a?(other)
        other == YiffSpace.config.user_like_class || super
      end
    end
  end
end
