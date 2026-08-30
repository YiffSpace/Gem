# frozen_string_literal: true

module Yiffspace
  # Scaffolds a new db/fixes/*.rb script for YiffSpace::FixTracker (see `rake fixes:list`).
  #
  # `--steps N` splits the fix into N ordered steps sharing an id, each one a copy of the generic
  # fixer.rb template. A host app can instead define a YiffSpace::FixerTemplate subclass (see that
  # class) to control both the step count and each step's file content, auto-discovered from
  # YiffSpace.config.fixer_templates_path - reachable here with `--template <name>`/`-t <name>`,
  # or with the template's own shortname flag if it registered one (e.g. `-e`).
  class FixerGenerator < Rails::Generators::NamedBase
    source_root(File.expand_path("templates", __dir__))
    # No short alias - -s/-f/-p/-q are already claimed by Rails::Generators::Base's own runtime
    # options (--skip/--force/--pretend/--quiet), and Thor silently lets the last-defined
    # class_option win a collision instead of erroring.
    class_option(:steps, type: :numeric, default: 1,
                          desc: "Split the fix into N ordered steps sharing an id, e.g. 12_1_name.rb, 12_2_name.rb")
    class_option(:template, type: :string, default: nil, aliases: ["-t"],
                             desc: "Use a fixer template registered with YiffSpace.config.fixer_templates")

    YiffSpace.config.fixer_templates.each do |template|
      next unless template.short

      class_option(template.name.to_sym, type: :boolean, default: false, aliases: ["-#{template.short}"],
                                          desc: "Shortcut for --template #{template.name}")
    end

    def create_fixer
      content_blocks = resolve_content_blocks

      id = Dir[File.join(destination_root, "db/fixes/*.rb")].map { |f| File.basename(f, ".rb").split("_").first.to_i }.max.to_i + 1

      if content_blocks.size == 1
        create_fixer_file("db/fixes/#{id}_#{file_name}.rb", content_blocks.first)
      else
        content_blocks.each_with_index { |block, index| create_fixer_file("db/fixes/#{id}_#{index + 1}_#{file_name}.rb", block) }
      end
    end

    private

    # One entry per step - a block returning that step's file content, or nil to fall back to
    # copying the generic fixer.rb template (a plain --steps N, or a manually
    # YiffSpace.config.fixer_templates.register'd template, has no per-step content).
    def resolve_content_blocks
      template = resolve_template
      return template.content_blocks if template

      Array.new(steps_from_flag)
    end

    def resolve_template
      name = template_name
      return nil if name.nil?

      template = YiffSpace.config.fixer_templates[name]
      raise(Thor::Error, "no fixer template named #{name.inspect} is registered") unless template

      template
    end

    # The template chosen via `--template <name>`, or via a registered template's own shortname
    # flag (e.g. `-e` for a template registered with `short: "e"`) - nil if neither was passed.
    def template_name
      return options["template"] if options["template"]

      YiffSpace.config.fixer_templates.find { |template| template.short && options[template.name] }&.name
    end

    def steps_from_flag
      steps = options["steps"].to_i
      raise(Thor::Error, "--steps must be at least 1") if steps < 1

      steps
    end

    def create_fixer_file(path, content_block)
      if content_block
        create_file(path, content_block.call)
        chmod(path, "+x")
      else
        copy_file("fixer.rb", path, mode: :preserve)
      end
    end
  end
end
