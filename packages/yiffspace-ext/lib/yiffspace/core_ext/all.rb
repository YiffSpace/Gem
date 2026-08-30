# frozen_string_literal: true

require_relative("active_record/where_chain")
require_relative("enumerable/all")
require_relative("hash/all")
require_relative("object/all")
require_relative("string/all")

# yiffspace-arel's lateral-join/unnest core_ext, only if that gem happens to be installed too.
begin
  require("yiffspace/core_ext/active_record/all")
rescue LoadError
  nil
end
