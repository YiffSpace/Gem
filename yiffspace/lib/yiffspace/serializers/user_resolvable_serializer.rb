# frozen_string_literal: true

require("active_job")

module YiffSpace
  module Serializers
    class UserResolvableSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(arg)
        super("user" => arg.user&.id, "ip_addr" => arg.ip_addr)
      end

      def deserialize(arg)
        YiffSpace.config.user_resolvable_class.new(arg["user"].blank? ? nil : YiffSpace.config.user_class.find(arg["user"]), arg["ip_addr"])
      end

      def klass
        YiffSpace.config.user_resolvable_class
      end
    end
  end
end
