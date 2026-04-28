# frozen_string_literal: true

require_relative("../../extensions/hash/to_open_hash")

class Hash
  include(YiffSpace::Extensions::Hash::ToOpenHash)
end
