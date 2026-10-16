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

      test("run_fix runs and records every pending step sharing an id") do
        klass = migration_class { def change = run_fix(2) }
        klass.new.migrate(:up)

        assert(FixTracker.applied?("2_1_first_step"))
        assert(FixTracker.applied?("2_2_second_step"))
      end

      test("run_fix skips fixes that are already applied") do
        FixTracker.record!("1_example_fix")
        klass = migration_class { def change = run_fix(1) }

        assert_output(/1_example_fix already applied, skipping/) { klass.new.migrate(:up) }
      end

      test("run_fix does nothing when the migration is rolled back") do
        klass = migration_class { def change = run_fix(1) }
        klass.new.migrate(:down)

        assert_not(FixTracker.applied?("1_example_fix"))
      end

      test("a fix run by run_fix can require the migration running it") do
        fix_path = Rails.root.join("db/fixes/91_requires_running_migration.rb")
        fix_path.write(%(requires_migration!("20990101000000")\n))
        klass = migration_class { def change = run_fix(91) }
        klass.new("RunsFix", 20_990_101_000_000).migrate(:up)

        assert(FixTracker.applied?("91_requires_running_migration"))
        assert_not(FixTracker.migration_running?("20990101000000"))
      ensure
        fix_path.delete if fix_path.exist?
      end

      test("a fix requiring a migration still raises when run by a different one") do
        fix_path = Rails.root.join("db/fixes/91_requires_running_migration.rb")
        fix_path.write(%(requires_migration!("20990101000000")\n))
        klass = migration_class { def change = run_fix(91) }

        assert_raises(FixTracker::MigrationRequired) { klass.new("RunsFix", 20_990_102_000_000).migrate(:up) }
      ensure
        fix_path.delete if fix_path.exist?
      end

      test("run_fix raises when the fix doesn't exist") do
        klass = migration_class { def change = run_fix(999) }

        assert_raises(ArgumentError) { klass.new.migrate(:up) }
      end

      test("fixes_run_by reads run_fix calls out of a migration file") do
        path = Rails.root.join("tmp/run_fix_fixture.rb")
        path.write(<<~RUBY)
          class RunFixFixture < ActiveRecord::Migration[8.1]
            def change
              run_fix(3)
              run_fix("2_1_first_step")
            end
          end
        RUBY

        assert_equal([3, "2_1_first_step"], RequiresFix.fixes_run_by(path))
      ensure
        path.delete if path.exist?
      end

      private

      def migration_class(&)
        Class.new(ActiveRecord::Migration[8.1]) do
          def change; end

          class_eval(&)
        end
      end
    end
  end
end
