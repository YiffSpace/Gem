# frozen_string_literal: true

module YiffSpace
  module Extensions
    module Hash
      module ToOpenHash
        def to_open_hash
          ::YiffSpace::Utils::OpenHash.from(self)
        end

        alias with_open_access to_open_hash
      end
    end
  end
end
