# YiffSpace

Ruby gems for https://yiff.space and related projects, split for complete
modularity - depend on just what you need, or on the `yiffspace` husk for
everything.

- [`yiffspace`](yiffspace) - husk, depends on every gem below
- [`yiffspace-core`](yiffspace-core) - Rails engine, Configuration, shared concerns/utils
- [`yiffspace-config`](yiffspace-config) - standalone `ConfigBuilder`, no dependency on the rest
- [`yiffspace-ext`](yiffspace-ext) - generic core extensions + `WhereChain`, no dependency on the rest
- [`yiffspace-arel`](yiffspace-arel) - Postgres lateral-join/unnest extensions, no dependency on the rest
- [`yiffspace-images`](yiffspace-images) - avatar/banner URLs, depends on `yiffspace-core`
- [`yiffspace-tables`](yiffspace-tables) - HTML table-building DSL, depends on `yiffspace-core`
- [`yiffspace-user`](yiffspace-user) - User/Current/Resolvable concerns, depends on `yiffspace-core`
- [`yiffspace-search`](yiffspace-search) - query-param search DSL, depends on `yiffspace-core`/`yiffspace-ext`/`yiffspace-user`
- [`yiffspace-include`](yiffspace-include) - deprecated global-constant aliases, loads whichever of the above happen to be installed
- [`yiffspace-auth`](yiffspace-auth) - Logto-based auth engine, depends on `yiffspace-core`
- [`yiffspace-fixers`](yiffspace-fixers) - one-time `db/fixes` scripts, depends on `yiffspace-core`

Each gem has its own Gemfile, gemspec, tests, and publish script - see the
README in its directory.

## Contributing

Go away

## License

All gems are available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
