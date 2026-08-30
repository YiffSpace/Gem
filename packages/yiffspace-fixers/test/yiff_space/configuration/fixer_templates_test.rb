# frozen_string_literal: true

require("test_helper")

module YiffSpace
  class Configuration
    class FixerTemplatesTest < ActiveSupport::TestCase
      setup do
        @templates = FixerTemplates.new
        # Isolate from the real db/fixer_templates directory (and its ElasticsearchTemplate) -
        # discovery itself is covered separately in test/yiff_space/fixer_template_test.rb.
        @original_path = YiffSpace.config.fixer_templates_path
        YiffSpace.config.fixer_templates_path = "/nonexistent/#{SecureRandom.hex(8)}"
      end

      teardown { YiffSpace.config.fixer_templates_path = @original_path }

      test("register makes a template reachable by name") do
        @templates.register(:elasticsearch, steps: 2, short: "e")

        template = @templates["elasticsearch"]
        assert_equal("elasticsearch", template.name)
        assert_equal(2, template.steps)
        assert_equal("e", template.short)
      end

      test("short is optional") do
        @templates.register(:solo, steps: 3)

        assert_nil(@templates["solo"].short)
      end

      test("short strips a leading dash") do
        @templates.register(:elasticsearch, steps: 2, short: "-e")

        assert_equal("e", @templates["elasticsearch"].short)
      end

      test("register rejects a duplicate name") do
        @templates.register(:elasticsearch, steps: 2)

        assert_raises(ArgumentError) { @templates.register(:elasticsearch, steps: 3) }
      end

      test("register rejects a duplicate short") do
        @templates.register(:elasticsearch, steps: 2, short: "e")

        assert_raises(ArgumentError) { @templates.register(:opensearch, steps: 2, short: "e") }
      end

      test("register rejects a short reserved by the generator's own options") do
        assert_raises(ArgumentError) { @templates.register(:template_flag, steps: 2, short: "t") }
        assert_raises(ArgumentError) { @templates.register(:skip_flag, steps: 2, short: "s") }
      end

      test("register rejects a non-positive steps count") do
        assert_raises(ArgumentError) { @templates.register(:zero, steps: 0) }
        assert_raises(ArgumentError) { @templates.register(:negative, steps: -1) }
      end

      test("a registered template's steps fall back to the generic template (no content block)") do
        @templates.register(:legacy, steps: 2)

        assert_equal([nil, nil], @templates["legacy"].content_blocks)
      end

      test("[] returns nil for an unregistered name") do
        assert_nil(@templates["nonexistent"])
      end

      test("is enumerable over the registered templates") do
        @templates.register(:elasticsearch, steps: 2, short: "e")
        @templates.register(:solo, steps: 3)

        assert_equal(%w[elasticsearch solo], @templates.map(&:name))
      end
    end
  end
end
