# YiffSpace::Tables

HTML table-building DSL (`YiffSpace::Tables::Builder`), for
https://yiff.space and related projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-tables"
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
YiffSpace::Tables::Builder.new(@tags) do |table|
  table.column(:name)
  table.column(:post_count)
end
```

See `YiffSpace::Tables::Builder` for the full API.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
