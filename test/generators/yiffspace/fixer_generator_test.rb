# frozen_string_literal: true

require("test_helper")
require("rails/generators/test_case")
require("generators/yiffspace/fixer/fixer_generator")

module Yiffspace
  class FixerGeneratorTest < Rails::Generators::TestCase
    tests(FixerGenerator)
    destination(File.expand_path("../../tmp/fixer_generator", __dir__))
    setup(:prepare_destination)

    test("with no options, generates a single fix file from the generic template") do
      run_generator(%w[plain_fix])

      assert_file("db/fixes/1_plain_fix.rb", /require.*"config", "environment"/)
    end

    test("--steps splits the fix into N ordered files, each a copy of the generic template") do
      run_generator(%w[split_fix --steps 2])

      assert_file("db/fixes/1_1_split_fix.rb", /require.*"config", "environment"/)
      assert_file("db/fixes/1_2_split_fix.rb", /require.*"config", "environment"/)
    end

    test("--template writes each discovered FixerTemplate step's own content") do
      run_generator(%w[es_fix --template elasticsearch])

      assert_file("db/fixes/1_1_es_fix.rb", "# step 1 - add the elasticsearch index\n")
      assert_file("db/fixes/1_2_es_fix.rb", "# step 2 - backfill the elasticsearch data\n")
    end

    test("-t resolves a discovered template the same as --template") do
      run_generator(%w[es_fix -t elasticsearch])

      assert_file("db/fixes/1_1_es_fix.rb", "# step 1 - add the elasticsearch index\n")
      assert_file("db/fixes/1_2_es_fix.rb", "# step 2 - backfill the elasticsearch data\n")
    end

    test("a template's own shortname flag resolves the same as --template") do
      run_generator(%w[es_fix -e])

      assert_file("db/fixes/1_1_es_fix.rb", "# step 1 - add the elasticsearch index\n")
      assert_file("db/fixes/1_2_es_fix.rb", "# step 2 - backfill the elasticsearch data\n")
    end

    test("a manually registered template with no content falls back to the generic template") do
      run_generator(%w[legacy_fix --template legacy])

      %w[1 2 3].each { |step| assert_file("db/fixes/1_#{step}_legacy_fix.rb", /require.*"config", "environment"/) }
    end

    test("an unregistered --template name fails without creating a fix file") do
      error_output = capture(:stderr) { run_generator(%w[bad_fix --template nonexistent]) }

      assert_match(/no fixer template named "nonexistent" is registered/, error_output)
      assert_no_file("db/fixes/1_bad_fix.rb")
    end

    test("the next fix id continues from the highest existing one") do
      run_generator(%w[first])
      run_generator(%w[second])

      assert_file("db/fixes/1_first.rb")
      assert_file("db/fixes/2_second.rb")
    end
  end
end
