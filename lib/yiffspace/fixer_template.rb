# frozen_string_literal: true

module YiffSpace
  # Base class for a `bin/rails generate yiffspace:fixer` template, auto-discovered from *.rb
  # files in YiffSpace.config.fixer_templates_path (default db/fixer_templates) - no explicit
  # registration needed, just define a subclass:
  #
  #   class ElasticsearchTemplate < YiffSpace::FixerTemplate
  #     short("e")
  #
  #     step { "..." }
  #     step { "..." }
  #   end
  #
  # The template's name comes from the class name with a trailing "Template" dropped and
  # kebab-cased (ElasticsearchTemplate -> "elasticsearch", OpenSearchTemplate -> "open-search"),
  # reachable as `--template <name>` (see Yiffspace::FixerGenerator). Its step count is the
  # number of `step` blocks - each one's return value becomes that step's fix file content,
  # instead of the generic fixer.rb template a plain `--steps N` copies for every step.
  class FixerTemplate
    class << self
      # Optional - a template is always reachable via `--template <name>`, a registered
      # shortname flag (e.g. `-e`) is just a convenient alias for it.
      def short(value = nil)
        @short = value.to_s.delete_prefix("-") unless value.nil?
        @short
      end

      def step(&block)
        raise(ArgumentError, "#{name}.step requires a block") unless block

        steps << block
      end

      def steps
        @steps ||= []
      end

      def template_name
        name.demodulize.delete_suffix("Template").underscore.dasherize
      end
    end
  end
end
