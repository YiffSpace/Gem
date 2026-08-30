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

See `YiffSpace::FixTracker` and `YiffSpace::FixerTemplate` for the full API.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
