# frozen_string_literal: true

require("yiffspace/core")
require("zeitwerk")

loader = Zeitwerk::Loader.for_gem_extension(YiffSpace)
loader.ignore("#{__dir__}/fixers/engine.rb")
loader.setup

# Require the engine eagerly so it registers with Rails before the host app's
# active_support.initialize_per_engine_zeitwerk_loaders initializer runs - same reasoning as
# yiffspace's own engine.rb/yiffspace-auth's auth/engine.rb.
require_relative("fixers/engine") if defined?(Rails)

module YiffSpace
  module Fixers
  end

  class Configuration
    # Named `--steps` presets for `bin/rails generate yiffspace:fixer`. See
    # YiffSpace::Configuration::FixerTemplates.
    def fixer_templates
      @fixer_templates ||= FixerTemplates.new
    end

    # Directory scanned for YiffSpace::FixerTemplate subclasses (see FixerTemplate) - defaults to
    # db/fixer_templates in the host app.
    attr_writer(:fixer_templates_path)

    def fixer_templates_path
      @fixer_templates_path ||= Rails.root.join("db/fixer_templates")
    end
  end
end
