# frozen_string_literal: true

require("active_record/relation")
require_relative("unnest")
require_relative("../../extensions/active_record/left_unnest")

ActiveRecord::Relation.include(YiffSpace::Extensions::ActiveRecord::LeftUnnest)
