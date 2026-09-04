# frozen_string_literal: true

require("test_helper")

module YiffSpace
  module Fixers
    class RequiresFixTest < ActiveSupport::TestCase
      test("ActiveRecord::Migration is extended with requires_fix/required_fixes") do
        assert(ActiveRecord::Migration.respond_to?(:requires_fix))
      end

      test("requires_fix appends to the migration's own required_fixes, independent of other migrations") do
        klass = migration_class { requires_fix(1) }

        assert_equal([1], klass.required_fixes)
      end

      test("migrate raises when a required fix hasn't been applied yet") do
        klass = migration_class { requires_fix(1) }

        error = assert_raises(RequiresFix::FixRequired) { klass.new.migrate(:up) }
        assert_match(/1_example_fix/, error.message)
      end

      test("migrate succeeds once the required fix is recorded as applied") do
        FixTracker.record!("1_example_fix")
        klass = migration_class { requires_fix(1) }

        assert_nothing_raised { klass.new.migrate(:up) }
      end

      test("requires_fix(id) is satisfied only once every step sharing that id is applied") do
        FixTracker.record!("2_1_first_step")
        klass = migration_class { requires_fix(2) }

        error = assert_raises(RequiresFix::FixRequired) { klass.new.migrate(:up) }
        assert_match(/2_2_second_step/, error.message)
      end

      test("migrate raises when the required fix doesn't exist at all") do
        klass = migration_class { requires_fix(999) }

        assert_raises(RequiresFix::FixRequired) { klass.new.migrate(:up) }
      end

      test("migrating :down does not check required fixes") do
        klass = migration_class { requires_fix(999) }

        assert_nothing_raised { klass.new.migrate(:down) }
      end

      private

      def migration_class(&)
        Class.new(ActiveRecord::Migration[8.1]) do
          class_eval(&)

          def change; end
        end
      end
    end
  end
end
