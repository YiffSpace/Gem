# frozen_string_literal: true

module YiffSpace
  module Utils
    class Current < ActiveSupport::CurrentAttributes
      attribute(:user, :ip_addr, :request)

      def initialize
        super
        reset
      end

      after_reset do
        attributes[:user]    = YiffSpace.config.anonymous_user_getter.call
        attributes[:ip_addr] = YiffSpace.config.default_ip_address
      end

      def user
        value = super
        return value if value.is_a?(YiffSpace.config.user_resolvable_class) || !value.is_a?(YiffSpace.config.user_class)
        return YiffSpace.config.user_resolvable_class.new(value, ip_addr) if ip_addr.present?

        value
      end

      def user=(value)
        if value.is_a?(YiffSpace.config.user_resolvable_class)
          self.ip_addr = value.ip_addr
          value = value.user
        end
        super
      end

      def self.scoped(user, ip_addr = YiffSpace.config.default_ip_address, &)
        set(user: user, ip_addr: ip_addr, &)
      end

      def self.as_system(&)
        scoped(YiffSpace.config.system_user_getter.call, &)
      end
    end
  end
end
