# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Object
      module TruthyFalsy
        def truthy?
          case self
          when ::String
            match?(/\A(true|t|yes|y|on|1)\z/i)
          when ::TrueClass
            true
          when ::FalseClass
            false
          else
            to_s.truthy?
          end
        end

        def falsy?
          case self
          when ::String
            match?(/\A(false|f|no|n|off|0)\z/i)
          when ::TrueClass
            false
          when ::FalseClass
            true
          else
            to_s.falsy?
          end
        end
      end
    end
  end
end
