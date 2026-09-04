# frozen_string_literal: true

require("test_helper")

module YiffSpace
  class FixTrackerTest < ActiveSupport::TestCase
    test("key_for splits the id and optional index out of a fix filename") do
      assert_equal([1, nil], FixTracker.key_for("1_example_fix"))
      assert_equal([2, 1], FixTracker.key_for("2_1_first_step"))
    end

    test("sort_key orders by the numeric id/index pair, not the filename string") do
      names = %w[2_2_second_step 12_something 2_1_first_step 1_example_fix]
      assert_equal(
        %w[1_example_fix 2_1_first_step 2_2_second_step 12_something],
        names.sort_by { |name| FixTracker.sort_key(name) },
      )
    end

    test("all_fixes lists only numbered fixes, sorted, and ignores reusable scripts") do
      assert_equal(%w[1_example_fix 2_1_first_step 2_2_second_step], FixTracker.all_fixes)
    end

    test("fix_path finds a fix script by its full name") do
      assert_match(%r{db/fixes/1_example_fix\.rb\z}, FixTracker.fix_path("1_example_fix").to_s)
    end

    test("record! and applied?/applied track a fix as applied") do
      assert_not(FixTracker.applied?("1_example_fix"))

      FixTracker.record!("1_example_fix")

      assert(FixTracker.applied?("1_example_fix"))
      assert_includes(FixTracker.applied, [1, nil])
    end

    test("record! is idempotent") do
      FixTracker.record!("2_1_first_step")
      assert_nothing_raised { FixTracker.record!("2_1_first_step") }
      assert(FixTracker.applied?("2_1_first_step"))
    end

    test("pending excludes fixes already recorded as applied") do
      FixTracker.record!("1_example_fix")

      assert_equal(%w[2_1_first_step 2_2_second_step], FixTracker.pending)
    end

    test("run! loads the fix script and records it as applied") do
      assert_equal("1_example_fix", FixTracker.run!(FixTracker.fix_path("1_example_fix")))
      assert(FixTracker.applied?("1_example_fix"))
    end

    test("migration_applied? is true for a version recorded in schema_migrations") do
      assert(FixTracker.migration_applied?("20260822004454"))
    end

    test("migration_applied? is false for a version never applied") do
      assert_not(FixTracker.migration_applied?("20990101000000"))
    end

    test("requires_migration! is a no-op when the migration has been applied") do
      assert_nothing_raised { FixTracker.requires_migration!("20260822004454") }
    end

    test("requires_migration! raises when the migration hasn't been applied") do
      error = assert_raises(FixTracker::MigrationRequired) { FixTracker.requires_migration!("20990101000000") }
      assert_match(/20990101000000/, error.message)
    end

    test("resolve with an Integer id returns every step sharing that id") do
      assert_equal(%w[2_1_first_step 2_2_second_step], FixTracker.resolve(2))
    end

    test("resolve with an Integer id returns a single-element array for a fix with no steps") do
      assert_equal(%w[1_example_fix], FixTracker.resolve(1))
    end

    test("resolve with a name returns just that fix") do
      assert_equal(%w[2_1_first_step], FixTracker.resolve("2_1_first_step"))
    end

    test("resolve returns an empty array for an id/name that doesn't exist") do
      assert_equal([], FixTracker.resolve(999))
      assert_equal([], FixTracker.resolve("nonexistent"))
    end

    test("required_migration_for reads a fix's declared requires_migration! version without running it") do
      path = Rails.root.join("db/fixes/99_requires_migration_fixture.rb")
      path.write(<<~RUBY)
        #!/usr/bin/env ruby
        # frozen_string_literal: true

        YiffSpace::FixTracker.requires_migration!("20260822004454")

        raise("this fix must not be executed by required_migration_for")
      RUBY

      assert_equal("20260822004454", FixTracker.required_migration_for("99_requires_migration_fixture"))
    ensure
      path&.delete
    end

    test("required_migration_for is nil for a fix with no such call") do
      assert_nil(FixTracker.required_migration_for("1_example_fix"))
    end

    test("required_migration_for is nil for a fix that doesn't exist") do
      assert_nil(FixTracker.required_migration_for("nonexistent"))
    end
  end
end
