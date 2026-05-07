# frozen_string_literal: true

require("arel")

module YiffSpace
  module Extensions
    module Arel
      module Nodes
        class LeftJoinLateral < ::Arel::Nodes::Join
          def initialize(left, right = nil)
            super
          end
        end
      end
    end
  end
end
