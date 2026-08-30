# YiffSpace::Include

Deprecated global-constant aliases (`TableBuilder`, `UserLike`, `QueryBuilder`,
etc) for the classes that now live under `YiffSpace::*` across the various
`yiffspace-*` gems, for https://yiff.space and related projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-include"
```

And then execute:

```bash
$ bundle install
```

## Usage

Nothing loads just by requiring `"yiffspace/include"`. Pull in every alias
this gem knows about:

```ruby
require "yiffspace/include/all"
```

or a single one:

```ruby
require "yiffspace/include/table_builder" # defines the global TableBuilder
```

Each alias only loads if the gem that owns the real class is actually
installed - `require "yiffspace/include/table_builder"` is a no-op unless
`yiffspace-tables` is also in your Gemfile, for example.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
