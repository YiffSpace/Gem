# YiffSpace::Fixers

One-time `db/fixes/*.rb` scripts, tracked the same way ActiveRecord's own
`schema_migrations` tracks migrations - for https://yiff.space and related
projects. Lives alongside, and depends on, the [`yiffspace`](../yiffspace)
gem in this repo.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-fixers"
```

And then execute:

```bash
$ bundle install
$ bin/rails generate yiffspace:install:fixes
$ bin/rails db:migrate
```

## Usage

```bash
$ bin/rails generate yiffspace:fixer some_description
$ bin/rails fixes:list
$ bin/rails fixes:migrate
```

A fix can require that a migration has already been applied, and a migration can require that a
fix has already been applied - useful when one depends on schema or data the other provides.
`bin/rails fixes:migrate_all` runs both `db/migrate` and `db/fixes` together, in whichever order
those requirements demand:

```ruby
# db/fixes/12_backfill_widget_type.rb
YiffSpace::FixTracker.requires_migration!("20260822004454")

# db/migrate/20260901000000_remove_legacy_widget_column.rb
class RemoveLegacyWidgetColumn < ActiveRecord::Migration[8.1]
  requires_fix(12)

  def change
    ...
  end
end
```

See `YiffSpace::FixTracker`, `YiffSpace::FixerTemplate`, `YiffSpace::Fixers::RequiresFix`, and
`YiffSpace::MigrationSync` for the full API.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
