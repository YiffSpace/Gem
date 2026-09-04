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
    module RequiresFix
      # Raised when a migration runs before one of its required fixes has been applied.
      class FixRequired < StandardError; end

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
