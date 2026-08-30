# frozen_string_literal: true

require("active_record/relation")
require_relative("../arel/left_join_lateral")
require_relative("../../extensions/active_record/left_join_lateral")

ActiveRecord::Relation.include(YiffSpace::Extensions::ActiveRecord::LeftJoinLateral)
