# YiffSpace::Ext

Generic Ruby/ActiveRecord core extensions - `Object#to_b`/`#truthy?`/`#falsy?`,
`Hash#to_open_hash`, `Enumerable#parallel`, `String#to_escaped_for_sql_like`,
and the `.where` chain DSL (`.like`/`.ilike`/`.has_bits`/`.regex`/etc) - for
https://yiff.space and related projects. No dependency on `yiffspace` itself.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-ext"
```

And then execute:

```bash
$ bundle install
```

## Usage

The namespaced extensions live under `YiffSpace::Extensions::*` and are
autoloaded. The old global monkeypatch style is opt-in:

```ruby
require "yiffspace/core_ext/all" # or object/all, hash/all, etc individually
```

`core_ext/all` also picks up `yiffspace-arel`'s lateral-join/unnest globals
if that gem happens to be installed too.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
