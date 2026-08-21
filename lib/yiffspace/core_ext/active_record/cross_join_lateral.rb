# frozen_string_literal: true

require("active_record/relation")
require_relative("../arel/cross_join_lateral")
require_relative("../../extensions/active_record/cross_join_lateral")

ActiveRecord::Relation.include(YiffSpace::Extensions::ActiveRecord::CrossJoinLateral)
