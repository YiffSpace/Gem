# frozen_string_literal: true

module YiffSpace
  module Fixers
    # Adds `requires_fix` to ActiveRecord::Migration - the migration-side mirror of
    # YiffSpace::FixTracker.requires_migration! - so a migration can declare that one or more
    # db/fixes/*.rb scripts must already be applied before it runs, e.g.:
    #
    #   class BackfillWidgetType < ActiveRecord::Migration[8.1]
    #     requires_fix(3)
    #
    #     def change
    #       ...
    #     end
    #   end
    #
    # Checked whenever the migration actually runs (so plain `db:migrate` still refuses to run it
    # out of order), and read back ahead of time by YiffSpace::MigrationSync to order
    # `fixes:migrate_all` correctly. Included into ActiveRecord::Migration by
    # YiffSpace::Fixers::Engine.
    #
    # A migration can also run a fix itself, as part of migrating, with `run_fix`:
    #
    #   def change
    #     add_column(:widgets, :type, :string)
    #     run_fix(3)
    #   end
    #
    # Each fix it covers is run and recorded the same as YiffSpace::FixTracker.run!, unless it's
    # already applied, and inside the migration's transaction. Fixes can't be undone, so it does
    # nothing when the migration is rolled back. A fix run this way can requires_migration! the
    # migration running it.
    module RequiresFix
      # Raised when a migration runs before one of its required fixes has been applied.
      class FixRequired < StandardError; end

      # Same idea as YiffSpace::FixTracker::REQUIRES_MIGRATION_PATTERN - lets
      # YiffSpace::MigrationSync read the fixes a migration runs out of its file, so
      # `fixes:migrate_all` leaves them to the migration instead of running them on their own.
      RUN_FIX_PATTERN = /^\s*run_fix\(\s*(?:(\d+)|["']([^"']+)["'])\s*\)/

      # The id_or_name of every run_fix call in a migration file.
      def self.fixes_run_by(path)
        File.read(path).scan(RUN_FIX_PATTERN).map { |id, name| id ? id.to_i : name }
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.prepend(InstanceMethods)
      end

      module ClassMethods
        # id_or_name: a fix's leading id (e.g. 3, covers every step sharing that id) or its full
        # file name (e.g. "2_1_first_step") for one specific step - see YiffSpace::FixTracker#resolve.
        def requires_fix(id_or_name)
          required_fixes << id_or_name
        end

        def required_fixes
          @required_fixes ||= []
        end
      end

      module InstanceMethods
        def migrate(direction)
          check_required_fixes! if direction == :up

          super
        end

        # id_or_name: same as requires_fix.
        def run_fix(id_or_name)
          return if reverting?

          names = YiffSpace::FixTracker.resolve(id_or_name)
          raise(ArgumentError, "#{self.class.name} runs fix #{id_or_name.inspect}, which does not exist") if names.empty?

          names.each do |name|
            if YiffSpace::FixTracker.applied?(name)
              say("#{name} already applied, skipping")
            else
              say_with_time("run_fix(#{name.inspect})") do
                YiffSpace::FixTracker.running_migration(version) { YiffSpace::FixTracker.run!(YiffSpace::FixTracker.fix_path(name)) }
              end
            end
          end
        end

        private

        def check_required_fixes!
          self.class.required_fixes.each do |id_or_name|
            names = YiffSpace::FixTracker.resolve(id_or_name)
            raise(FixRequired, "#{self.class.name} requires fix #{id_or_name.inspect}, which does not exist") if names.empty?

            missing = names.reject { |name| YiffSpace::FixTracker.applied?(name) }
            raise(FixRequired, "#{self.class.name} requires #{missing.join(', ')} to be applied first") if missing.any?
          end
        end
      end
    end
  end
end
