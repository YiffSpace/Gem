# frozen_string_literal: true

# Fixture template for test/generators/yiffspace/fixer_generator_test.rb - auto-discovered from
# YiffSpace.config.fixer_templates_path (see YiffSpace::FixerTemplate).
class ElasticsearchTemplate < YiffSpace::FixerTemplate
  short("e")

  step { "# step 1 - add the elasticsearch index\n" }
  step { "# step 2 - backfill the elasticsearch data\n" }
end
