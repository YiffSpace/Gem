# frozen_string_literal: true

module YiffSpace
  module Images
    module Avatar
      class Base
        def self.type = nil

        attr_reader(:id, :type)

        def initialize(id, type)
          @id   = id
          @type = type
        end

        def url
          raise(NotImplementedError)
        end

        def update(*)
          raise(NotImplementedError)
        end

        def serializable_hash(*)
          { "id" => @id, "type" => @type }
        end

        def self.from_json(data)
          raise(ArgumentError, "invalid data") if data.blank?

          data = JSON.parse(data) if data.is_a?(String)
          data = ::YiffSpace::Utils::OpenHash.from(data)

          return Avatar.find_type(data.type).from_json(data) if self == Base

          new(data.id)
        end
      end
    end
  end
end
