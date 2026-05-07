# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Arel
      module Nodes
        class CrossJoinLateral < ::Arel::Nodes::Join
          def initialize(left, right = nil)
            super
          end
        end
      end
    end
  end
end
