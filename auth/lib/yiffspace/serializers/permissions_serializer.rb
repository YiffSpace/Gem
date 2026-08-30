# frozen_string_literal: true

require("active_job")

module YiffSpace
  module Serializers
    class PermissionsSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(arg)
        super("value" => arg.value)
      end

      def deserialize(arg)
        Auth::Permissions.new(arg["value"])
      end

      def klass
        Auth::Permissions
      end
    end
  end
end
