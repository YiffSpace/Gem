# YiffSpace::Arel

Postgres lateral-join/unnest ActiveRecord & Arel extensions
(`cross_join_lateral`, `left_join_lateral`, `unnest`, `cross_unnest`,
`left_unnest`), for https://yiff.space and related projects. No dependency
on `yiffspace` itself - pure additive ActiveRecord/Arel monkeypatches.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-arel"
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
Post.joins_lateral_unnest # etc - see YiffSpace::Extensions::ActiveRecord::*
```

The old global monkeypatch style (`core_ext/**`) is still available via
`require("yiffspace/core_ext/active_record/all")`, aliasing the same
behavior onto `ActiveRecord::Relation`/`Arel` directly.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
