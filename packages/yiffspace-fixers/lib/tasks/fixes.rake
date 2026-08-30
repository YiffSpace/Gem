# frozen_string_literal: true

# Keep structure.sql's fixes rows in sync with the database on every schema dump, the same way
# ActiveRecord keeps schema_migrations rows in sync - not just when `fixes:migrate` runs.
Rake::Task["db:schema:dump"].enhance do
  YiffSpace::FixTracker.dump_structure_sql!
end

namespace(:fixes) do
  desc("List available fix scripts in db/fixes, marking which have already been applied")
  task(list: :environment) do
    applied = YiffSpace::FixTracker.applied
    YiffSpace::FixTracker.all_fixes.each do |name|
      puts("#{applied.include?(YiffSpace::FixTracker.key_for(name)) ? '[x]' : '[ ]'} #{name}")
    end
  end

  desc("Run a fix script from db/fixes by id or name, e.g. `rake fixes:run[1]` - re-runs even if already recorded as applied")
  task(:run, [:name] => :environment) do |_task, args|
    name = args[:name].to_s.delete_suffix(".rb")
    abort("Usage: rake fixes:run[id_or_name] (see `rake fixes:list`)") if name.blank?

    candidates = Dir["db/fixes/*.rb"]
    exact = candidates.find { |path| File.basename(path, ".rb") == name }
    matches = exact ? [exact] : candidates.select { |path| File.basename(path, ".rb").start_with?("#{name}_") || File.basename(path, ".rb").include?(name) }

    if matches.empty?
      abort("No fix matches \"#{name}\". Run `rake fixes:list` to see available fixes.")
    elsif matches.size > 1
      abort("Multiple fixes match \"#{name}\", be more specific:\n#{matches.map { |m| "  #{File.basename(m, '.rb')}" }.join("\n")}")
    end

    puts("Running #{File.basename(matches.first, '.rb')}...")
    name = YiffSpace::FixTracker.run!(matches.first)
    puts("Recorded #{name} as applied")
  end

  desc("Apply all fix scripts not yet recorded as applied, in order, then dump the schema like db:migrate does")
  task(migrate: :environment) do
    pending = YiffSpace::FixTracker.pending

    if pending.empty?
      puts("No pending fixes.")
    else
      pending.each do |name|
        puts("Running #{name}...")
        YiffSpace::FixTracker.run!(YiffSpace::FixTracker.fix_path(name))
        puts("Recorded #{name} as applied")
      end
    end

    Rake::Task["db:_dump"].invoke
  end

  desc("Record all of the current fixes as having been applied")
  task(load: :environment) do
    list = YiffSpace::FixTracker.all_fixes.map { YiffSpace::FixTracker.key_for(it) }
    existing = ActiveRecord::Base.connection.select_all('SELECT id, "index" FROM fixes ORDER BY id, "index"').rows
    list.reject! { |id, index| existing.any? { |e| e[0] == id && e[1] == index } }
    unless list.empty?
      values = list.map { |id, index| "(#{id}, #{index.nil? ? 'NULL' : index})" }.join(", ")
      ActiveRecord::Base.connection.execute(%(INSERT INTO fixes (id, "index") VALUES #{values}))
    end
    puts("Loaded #{list.length} #{'fix'.pluralize(list.length)}")
  end
end
