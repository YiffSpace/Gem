# frozen_string_literal: true

module YiffSpace
  # Tracks which db/fixes/*.rb scripts a host app has applied, in a `fixes` table (see
  # db/migrate/*_create_fixes.rb) the same way ActiveRecord's own schema_migrations table
  # tracks migrations. Used by the `fixes:*` rake tasks (lib/tasks/fixes.rake).
  module FixTracker
    module_function

    def fix_path(name)
      Rails.root.glob("db/fixes/#{name}.rb").first
    end

    # db/fixes filenames are "<id>_description.rb", occasionally "<id>_<index>_description.rb"
    # (e.g. 1_1_..., 1_2_...) for a handful of fixes split into ordered steps - the `fixes`
    # table mirrors this as an (id, index) pair, with index null for fixes with no subtype.
    def key_for(name)
      id, maybe_index = name.split("_", 3)
      index = maybe_index =~ /\A\d+\z/ ? maybe_index.to_i : nil
      [id.to_i, index]
    end

    # Sort on the (id, index) parts, not the filename string, so 12 doesn't sort before 2_2.
    def sort_key(name)
      id, index = key_for(name)
      [id, index || 0]
    end

    # Only numbered one-time fixes are tracked/auto-applied - a host app's db/fixes may also hold
    # reusable on-demand maintenance scripts that aren't meant to run automatically as part of
    # `fixes:migrate`. Those stay reachable via `fixes:run[name]`.
    def all_fixes
      Rails.root.glob("db/fixes/*.rb").map { |path| File.basename(path, ".rb") }.grep(/\A\d/).sort_by { |name| sort_key(name) }
    end

    def applied
      ActiveRecord::Base.connection.select_rows('SELECT id, "index" FROM fixes').to_set
    end

    def applied?(name)
      id, index = key_for(name)
      conn = ActiveRecord::Base.connection
      index_clause = index.nil? ? '"index" IS NULL' : %("index" = #{index})
      conn.select_value("SELECT 1 FROM fixes WHERE id = #{id} AND #{index_clause}").present?
    end

    def pending
      applied_keys = applied
      all_fixes.reject { |name| applied_keys.include?(key_for(name)) }
    end

    def record!(name)
      id, index = key_for(name)
      conn = ActiveRecord::Base.connection
      conn.execute(<<~SQL.squish)
        INSERT INTO fixes (id, "index") VALUES (#{id}, #{index || 'NULL'})
        ON CONFLICT (id, "index") DO NOTHING
      SQL
    end

    def run!(path)
      name = File.basename(path, ".rb")
      load(File.expand_path(path))
      record!(name)
      name
    end

    # Mirrors how ActiveRecord appends `INSERT INTO "schema_migrations"` to structure.sql after
    # a schema dump (see Connection#dump_schema_versions) - appends the currently-applied fixes
    # the same way, so loading structure.sql into a fresh database marks them applied too instead
    # of leaving `fixes:migrate` to re-run every historical fix. Hooked into `db:schema:dump` in
    # lib/tasks/fixes.rake, so it runs on every schema dump, not just `fixes:migrate`.
    def dump_structure_sql!
      db_config = ActiveRecord::Base.connection_db_config
      return unless db_config.schema_format == :sql

      filename = ActiveRecord::Tasks::DatabaseTasks.schema_dump_path(db_config)
      return unless filename && File.exist?(filename)

      conn = ActiveRecord::Base.connection
      return unless conn.table_exists?(:fixes)

      rows = conn.select_rows('SELECT id, "index" FROM fixes ORDER BY id DESC, "index" DESC NULLS LAST')
      return if rows.empty?

      values = rows.map { |id, index| "(#{id}, #{index || 'NULL'})" }.join(",\n")
      File.open(filename, "a") do |f|
        f.puts(<<~TEXT)
          INSERT INTO "fixes" (id, "index") VALUES
          #{values};
        TEXT
      end
    end
  end
end
