# frozen_string_literal: true

module Yiffspace
  module Install
    # Installs YiffSpace::FixTracker into a host app: `bin/rails generate yiffspace:install:fixes`
    # copies the `fixes` tracking table migration. Run `bin/rails db:migrate` afterwards.
    class FixesGenerator < Rails::Generators::Base
      include(Rails::Generators::Migration)

      source_root(File.expand_path("templates", __dir__))

      def self.next_migration_number(dirname)
        ActiveRecord::Migration.next_migration_number(current_migration_number(dirname) + 1)
      end

      def create_migration_file
        migration_template("create_fixes.rb.erb", "db/migrate/create_fixes.rb")
      end
    end
  end
end
