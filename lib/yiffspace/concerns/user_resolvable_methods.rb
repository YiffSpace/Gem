# frozen_string_literal: true

module YiffSpace
  module Concerns
    module UserResolvableMethods
      def resolvable(ip_addr = nil)
        UserResolvable.new(self, ip_addr || send(YiffSpace.config.last_ip_addr_attribute) || YiffSpace.config.default_ip_address)
      end

      def resolve
        self
      end

      def is?(user_or_id)
        id == u2id(user_or_id)
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

      include(YiffSpace::Utils::UserToId)

      private(:u2id)
    end
  end
end
