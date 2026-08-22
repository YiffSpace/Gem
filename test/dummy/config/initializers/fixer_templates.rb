# frozen_string_literal: true

# Fixture registration exercised by test/yiff_space/configuration/fixer_templates_test.rb and
# test/generators/yiffspace/fixer_generator_test.rb - kept separate from initializers/yiffspace.rb
# since that file is gitignored (holds this developer's local images update_token).
#
# The "elasticsearch" template itself lives in db/fixer_templates/elasticsearch_template.rb,
# auto-discovered - this registers a second one manually, to keep that API covered too.
YiffSpace.configure do |config|
  config.fixer_templates.register(:legacy, steps: 3)
end
