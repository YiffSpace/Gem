# frozen_string_literal: true

module YiffSpace
  # Computes and applies pending db/migrate/*.rb migrations and db/fixes/*.rb fixes together, in
  # whichever order their cross requirements demand - a fix can require a migration
  # (YiffSpace::FixTracker.requires_migration!) and a migration can require a fix
  # (YiffSpace::Fixers::RequiresFix#requires_fix). Migrations stay ordered among themselves by
  # version, fixes among themselves by YiffSpace::FixTracker.sort_key, and those cross
  # requirements are woven in via a topological sort. #plan/#apply are used by `rake
  # fixes:migrate_all` (see lib/tasks/fixes.rake).
  module MigrationSync
    # A single item in the computed #plan - kind is :migration (ref a MigrationProxy) or :fix
    # (ref a fix name).
    Step = Struct.new(:kind, :ref, :key)

    # Raised when a fix/migration requires something that isn't findable, or requirements form a
    # cycle (e.g. a fix requires a migration that itself requires that same fix).
    class UnresolvableOrder < StandardError; end

    module_function

    # The ordered list of pending Steps - migrations and fixes interleaved wherever a
    # requires_fix/requires_migration! forces it, otherwise each kept in its own natural order.
    def plan
      migrations = pending_migrations
      fixes = FixTracker.pending

      steps = {}
      migrations.each { |m| steps[[:migration, m.version]] = Step.new(:migration, m, [:migration, m.version]) }
      fixes.each { |f| steps[[:fix, f]] = Step.new(:fix, f, [:fix, f]) }

      edges = Hash.new { |h, k| h[k] = [] }
      indegree = steps.each_key.index_with(0)

      link = lambda do |before, after|
        next unless steps.key?(before) && steps.key?(after)

        edges[before] << after
        indegree[after] += 1
      end

      # Preserve each kind's own natural order as implicit dependencies.
      migrations.each_cons(2) { |a, b| link.call([:migration, a.version], [:migration, b.version]) }
      fixes.each_cons(2) { |a, b| link.call([:fix, a], [:fix, b]) }

      link_fix_requirements(fixes, link)
      link_migration_requirements(migrations, link)

      topological_sort(steps, edges, indegree)
    end

    def link_fix_requirements(fixes, link)
      fixes.each do |name|
        version = FixTracker.required_migration_for(name)
        next unless version
        raise(UnresolvableOrder, "#{name} requires migration #{version}, which does not exist") unless migration_exists?(version)

        link.call([:migration, version.to_i], [:fix, name])
      end
    end

    def link_migration_requirements(migrations, link)
      migrations.each do |m|
        migration_class_for(m).required_fixes.each do |id_or_name|
          names = FixTracker.resolve(id_or_name)
          raise(UnresolvableOrder, "#{m.name} requires fix #{id_or_name.inspect}, which does not exist") if names.empty?

          names.each { |name| link.call([:fix, name], [:migration, m.version]) }
        end
      end
    end

    # Kahn's algorithm - ready nodes are processed FIFO in `steps`' insertion order (migrations
    # before fixes when both are ready at once), so requirements only ever reorder things when
    # they actually have to.
    def topological_sort(steps, edges, indegree)
      ready = indegree.select { |_, count| count.zero? }.keys
      ordered = []

      until ready.empty?
        key = ready.shift
        ordered << steps.fetch(key)

        edges[key].each do |dependent|
          indegree[dependent] -= 1
          ready << dependent if indegree[dependent].zero?
        end
      end

      return ordered if ordered.size == steps.size

      stuck = (steps.keys - ordered.map(&:key)).map { |kind, ref| "#{kind}:#{ref}" }
      raise(UnresolvableOrder, "circular requirement between #{stuck.join(', ')}")
    end

    def describe(step)
      case step.kind
      when :migration then "Migrating #{step.ref.name} (#{step.ref.version})..."
      when :fix then "Running #{step.ref}..."
      end
    end

    # Applies a single Step from #plan - a migration is brought up to (and including) its own
    # version, a fix is run and recorded, same as FixTracker.run!.
    def apply(step)
      case step.kind
      when :migration
        migration_context.up(step.ref.version) { |candidate| candidate.version == step.ref.version }
      when :fix
        FixTracker.run!(FixTracker.fix_path(step.ref))
      end
    end

    def pending_migrations
      applied = migration_context.get_all_versions
      migration_context.migrations.reject { |m| applied.include?(m.version) }
    end

    def migration_exists?(version)
      migration_context.migrations.any? { |m| m.version == version.to_i }
    end

    # MigrationProxy defers loading the migration class until needed, via a private #migration
    # accessor - reading `required_fixes` off it needs that class loaded early too, so reach past
    # that privacy rather than reimplementing Rails' own file-loading/constantizing.
    def migration_class_for(proxy)
      proxy.send(:migration).class
    end

    def migration_context
      FixTracker.migration_context
    end
  end
end
