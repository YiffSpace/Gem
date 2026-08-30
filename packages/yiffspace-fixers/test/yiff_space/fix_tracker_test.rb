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
  end
end
