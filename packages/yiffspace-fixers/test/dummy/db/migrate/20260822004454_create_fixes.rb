# frozen_string_literal: true

# Tracks which db/fixes/*.rb scripts have been applied, the same way schema_migrations tracks
# migrations - see YiffSpace::FixTracker and `rake fixes:migrate`/`rake fixes:list`.
#
# `id` is the fix's own leading number (e.g. 12, 23), not a surrogate key, so it isn't unique on
# its own - a fix can be split into ordered sub-steps (12_1, 12_2, ...) that share an id and are
# distinguished by `index`. `index` is null for fixes with no subtype.
class CreateFixes < ActiveRecord::Migration[8.1]
  def change
    create_table(:fixes, id: false) do |t|
      t.integer(:id, null: false) # not a surrogate key, this is the fix's own leading number
      t.integer(:index)
    end

    add_index(:fixes, %i[id index], unique: true, nulls_not_distinct: true)
  end
end
