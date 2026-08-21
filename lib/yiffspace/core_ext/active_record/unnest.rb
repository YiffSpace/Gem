# frozen_string_literal: true

require("active_record/relation")
require_relative("cross_join_lateral")
require_relative("left_join_lateral")
require_relative("../../extensions/active_record/unnest")

ActiveRecord::Relation.include(YiffSpace::Extensions::ActiveRecord::Unnest)
