# frozen_string_literal: true

module YiffSpace
  module Images
    module Banner
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
      end
    end
  end
end
