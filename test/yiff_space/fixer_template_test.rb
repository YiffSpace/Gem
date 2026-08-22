# frozen_string_literal: true

require("test_helper")

module YiffSpace
  class FixerTemplateTest < ActiveSupport::TestCase
    class SoloWidgetTemplate < FixerTemplate
      step { "solo" }
    end

    class OpenSearchThingTemplate < FixerTemplate
      short("-w")
      step { "one" }
      step { "two" }
    end

    test("template_name drops a trailing Template and kebab-cases the rest") do
      assert_equal("solo-widget", SoloWidgetTemplate.template_name)
    end

    test("template_name dasherizes a multi-word class name") do
      assert_equal("open-search-thing", OpenSearchThingTemplate.template_name)
    end

    test("steps collects one block per `step` call, in order") do
      assert_equal(2, OpenSearchThingTemplate.steps.size)
      assert_equal(%w[one two], OpenSearchThingTemplate.steps.map(&:call))
    end

    test("short strips a leading dash") do
      assert_equal("w", OpenSearchThingTemplate.short)
    end

    test("short is nil when never called") do
      assert_nil(SoloWidgetTemplate.short)
    end

    test("step without a block raises") do
      klass = Class.new(FixerTemplate)
      assert_raises(ArgumentError) { klass.step }
    end

    test("subclasses each get their own independent steps/short") do
      assert_equal(1, SoloWidgetTemplate.steps.size)
      assert_equal(2, OpenSearchThingTemplate.steps.size)
      assert_nil(SoloWidgetTemplate.short)
      assert_equal("w", OpenSearchThingTemplate.short)
    end

    class DiscoveryTest < ActiveSupport::TestCase
      setup do
        @registry = Configuration::FixerTemplates.new
        @original_path = YiffSpace.config.fixer_templates_path
        @dir = Dir.mktmpdir
        YiffSpace.config.fixer_templates_path = @dir
      end

      teardown do
        YiffSpace.config.fixer_templates_path = @original_path
        FileUtils.remove_entry(@dir)
      end

      test("a FixerTemplate subclass file in the configured directory is auto-registered") do
        write_template("discovery_fixture_a_template.rb", <<~RUBY)
          class DiscoveryFixtureATemplate < YiffSpace::FixerTemplate
            short("z")
            step { "alpha" }
            step { "beta" }
          end
        RUBY

        template = @registry["discovery-fixture-a"]
        assert_equal("discovery-fixture-a", template.name)
        assert_equal("z", template.short)
        assert_equal(%w[alpha beta], template.content_blocks.map(&:call))
      end

      test("discovery only runs once per registry, even across multiple lookups") do
        write_template("discovery_fixture_b_template.rb", <<~RUBY)
          class DiscoveryFixtureBTemplate < YiffSpace::FixerTemplate
            step { "once" }
          end
        RUBY

        assert(@registry["discovery-fixture-b"])

        # Adding a second file after the first lookup should NOT be picked up by this registry.
        write_template("discovery_fixture_c_template.rb", <<~RUBY)
          class DiscoveryFixtureCTemplate < YiffSpace::FixerTemplate
            step { "late" }
          end
        RUBY

        assert_nil(@registry["discovery-fixture-c"])
      end

      test("a directory that doesn't exist is a no-op, not an error") do
        YiffSpace.config.fixer_templates_path = File.join(@dir, "nonexistent")

        assert_nothing_raised { @registry.to_a }
        assert_nil(@registry["anything"])
      end

      private

      def write_template(filename, content)
        File.write(File.join(@dir, filename), content)
      end
    end
  end
end
