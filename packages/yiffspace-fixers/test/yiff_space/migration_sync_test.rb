# frozen_string_literal: true

require("test_helper")

module YiffSpace
  class MigrationSyncTest < ActiveSupport::TestCase
    test("topological_sort keeps steps in their given order when nothing requires anything") do
      steps, edges, indegree = graph(%i[a b c])

      assert_equal(%i[a b c], MigrationSync.topological_sort(steps, edges, indegree).map(&:key))
    end

    test("topological_sort moves a required step ahead of the thing that requires it") do
      # b is listed after a (so would naturally sort last), but a requires b first.
      steps, edges, indegree = graph(%i[a b])
      link(edges, indegree, :b, :a)

      assert_equal(%i[b a], MigrationSync.topological_sort(steps, edges, indegree).map(&:key))
    end

    test("topological_sort raises UnresolvableOrder on a circular requirement") do
      steps, edges, indegree = graph(%i[a b])
      link(edges, indegree, :a, :b)
      link(edges, indegree, :b, :a)

      assert_raises(MigrationSync::UnresolvableOrder) { MigrationSync.topological_sort(steps, edges, indegree) }
    end

    class PlanTest < ActiveSupport::TestCase
      setup do
        # ActiveRecord rejects migration timestamps more than a day in the future, so this has to
        # be a real (near-)current one rather than an obviously-fake placeholder.
        @version = 1.minute.from_now.utc.strftime("%Y%m%d%H%M%S")
        @migration_path = Rails.root.join("db/migrate/#{@version}_migration_sync_fixture.rb")
        @fix_path = Rails.root.join("db/fixes/90_migration_sync_fixture_fix.rb")
      end

      teardown do
        @migration_path.delete if @migration_path.exist?
        @fix_path.delete if @fix_path.exist?
        Object.send(:remove_const, :MigrationSyncFixture) if Object.const_defined?(:MigrationSyncFixture)
      end

      test("a fix's requires_migration! pulls the migration ahead of it") do
        @migration_path.write(<<~RUBY)
          class MigrationSyncFixture < ActiveRecord::Migration[8.1]
            def change; end
          end
        RUBY
        @fix_path.write(<<~RUBY)
          #!/usr/bin/env ruby
          YiffSpace::FixTracker.requires_migration!("#{@version}")
        RUBY

        keys = YiffSpace::MigrationSync.plan.map(&:key)

        assert_operator(keys.index([:migration, @version.to_i]), :<, keys.index([:fix, "90_migration_sync_fixture_fix"]))
      end

      test("a migration's requires_fix pulls the fix ahead of it") do
        @migration_path.write(<<~RUBY)
          class MigrationSyncFixture < ActiveRecord::Migration[8.1]
            requires_fix(2)
            def change; end
          end
        RUBY

        keys = YiffSpace::MigrationSync.plan.map(&:key)

        assert_operator(keys.index([:fix, "2_2_second_step"]), :<, keys.index([:migration, @version.to_i]))
      end

      test("a fix requiring a migration that doesn't exist raises UnresolvableOrder") do
        @fix_path.write(<<~RUBY)
          #!/usr/bin/env ruby
          YiffSpace::FixTracker.requires_migration!("20990101999999")
        RUBY

        assert_raises(YiffSpace::MigrationSync::UnresolvableOrder) { YiffSpace::MigrationSync.plan }
      end
    end

    private

    def graph(keys)
      steps = keys.index_with { |key| MigrationSync::Step.new(:fix, key.to_s, key) }
      edges = Hash.new { |h, k| h[k] = [] }
      indegree = keys.index_with { 0 }
      [steps, edges, indegree]
    end

    def link(edges, indegree, before, after)
      edges[before] << after
      indegree[after] += 1
    end
  end
end
