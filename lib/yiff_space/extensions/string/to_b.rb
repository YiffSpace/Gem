# frozen_string_literal: true

module YiffSpace
  module Extensions
    module String
      module ToB
        def to_b
          !match?(/\A(false|f|no|n|off|0)\z/i)
        end
      end
    end
  end
end
