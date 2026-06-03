# frozen_string_literal: true

require("active_job")

module YiffSpace
  module Serializers
    class AvatarSerializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(arg)
        super(**arg.serializable_hash)
      end

      def deserialize(arg)
        Images::Avatar::Base.from_json(arg)
      end

      private

      def klass
        Images::Avatar::Base
      end
    end
  end
end
