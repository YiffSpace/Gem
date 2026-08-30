# YiffSpace

A husk that just depends on every `yiffspace-*` gem, for apps that want
everything instead of picking specific gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace"
```

And then execute:

```bash
$ bundle install
```

## What's in here

- [`yiffspace-core`](../yiffspace-core) - Rails engine, Configuration, shared concerns/utils
- [`yiffspace-config`](../yiffspace-config) - standalone `ConfigBuilder`
- [`yiffspace-ext`](../yiffspace-ext) - generic core extensions + `WhereChain`
- [`yiffspace-arel`](../yiffspace-arel) - Postgres lateral-join/unnest extensions
- [`yiffspace-images`](../yiffspace-images) - avatar/banner URLs
- [`yiffspace-tables`](../yiffspace-tables) - HTML table-building DSL
- [`yiffspace-search`](../yiffspace-search) - query-param search DSL
- [`yiffspace-user`](../yiffspace-user) - User/Current/Resolvable concerns
- [`yiffspace-include`](../yiffspace-include) - deprecated global-constant aliases
- [`yiffspace-auth`](../yiffspace-auth) - Logto-based auth engine
- [`yiffspace-fixers`](../yiffspace-fixers) - one-time db/fixes scripts

Only need a subset? Depend on the specific gem(s) instead of this one.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
