# frozen_string_literal: true

require("active_record/relation")
require_relative("../../extensions/active_record/where_chain")

ActiveRecord::QueryMethods::WhereChain.include(YiffSpace::Extensions::ActiveRecord::WhereChain)
