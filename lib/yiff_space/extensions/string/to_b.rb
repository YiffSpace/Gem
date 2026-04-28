# frozen_string_literal: true

module YiffSpace
  module Extensions
    module String
      module ToB
        def to_b
          !falsy?
        end
      end
    end
  end
end
