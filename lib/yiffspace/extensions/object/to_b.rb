# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Object
      module ToB
        def to_b
          case self
          when ::String
            !match?(/\A(false|f|no|n|off|0)\z/i)
          when ::TrueClass
            true
          when ::FalseClass
            false
          else
            to_s.to_b
          end
        end
      end
    end
  end
end
