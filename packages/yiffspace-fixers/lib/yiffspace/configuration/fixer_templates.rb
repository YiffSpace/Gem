# frozen_string_literal: true

module YiffSpace
  class Configuration
    # Named presets for `bin/rails generate yiffspace:fixer`, so `--template <name>` (or a
    # registered shortname flag) can stand in for `--steps N`. Populated two ways:
    #
    # - Automatically, from YiffSpace::FixerTemplate subclasses found in
    #   YiffSpace.config.fixer_templates_path (the common case - see FixerTemplate).
    # - Manually, via #register, for a preset that just needs a step count and no per-step
    #   content (every step falls back to the generic fixer.rb template).
    #
    # See YiffSpace::Configuration#fixer_templates and Yiffspace::FixerGenerator.
    class FixerTemplates
      include(Enumerable)

      Template = Struct.new(:name, :short, :content_blocks, keyword_init: true) do
        def steps
          content_blocks.size
        end
      end

      # -t is yiffspace:fixer's own --template flag; -f/-p/-q/-s are Rails::Generators::Base's
      # built-in runtime options (--force/--pretend/--quiet/--skip).
      RESERVED_SHORTS = %w[t f p q s].freeze

      def initialize
        @templates = {}
        @discovered = false
      end

      # short is optional - a template is always reachable via `--template <name>`, a shortname
      # flag (e.g. `-e`) is just a convenient alias for it.
      def register(name, steps:, short: nil)
        raise(ArgumentError, "steps must be a positive integer, got #{steps.inspect}") unless steps.is_a?(Integer) && steps.positive?

        add(name.to_s, short: short, content_blocks: Array.new(steps))
      end

      def [](name)
        discover!
        @templates[name.to_s]
      end

      def each(&)
        discover!
        @templates.each_value(&)
      end

      private

      def add(name, short:, content_blocks:)
        raise(ArgumentError, "a fixer template named #{name.inspect} is already registered") if @templates.key?(name)

        short = short.to_s.delete_prefix("-") if short
        if short
          raise(ArgumentError, "\"-#{short}\" is reserved by yiffspace:fixer's own options") if RESERVED_SHORTS.include?(short)

          existing = @templates.values.find { |template| template.short == short }
          raise(ArgumentError, "\"-#{short}\" is already registered to the #{existing.name.inspect} fixer template") if existing
        end

        @templates[name] = Template.new(name: name, short: short, content_blocks: content_blocks)
      end

      # Scans YiffSpace.config.fixer_templates_path for YiffSpace::FixerTemplate subclasses and
      # registers each one - runs once, the first time a template is looked up (#[] or #each),
      # so it sees whatever the host app registered manually beforehand.
      def discover!
        return if @discovered

        @discovered = true
        path = YiffSpace.config.fixer_templates_path
        return unless path && Dir.exist?(path)

        before = FixerTemplate.subclasses
        Dir[File.join(path, "*.rb")].each { |file| require(file) }

        (FixerTemplate.subclasses - before).each do |klass|
          raise(ArgumentError, "#{klass.name} has no step blocks - add at least one `step { ... }`") if klass.steps.empty?

          add(klass.template_name, short: klass.short, content_blocks: klass.steps)
        end
      end
    end
  end
end
