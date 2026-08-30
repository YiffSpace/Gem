# YiffSpace::Config

Standalone ENV-backed config DSL (`YiffSpace::Config::Builder`), for
https://yiff.space and related projects. Not a Rails engine - no dependency
on `yiffspace` itself, only ActiveSupport.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-config"
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
class Config < YiffSpace::Config::Builder
  config(:some_value, required: true)
  config(:some_flag, :boolean) { false }
end
```

See `YiffSpace::Config::Builder` for the full API.

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
