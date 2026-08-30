# YiffSpace::Images

Avatar/banner URL building and updating (Discord/Gravatar), for
https://yiff.space and related projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "yiffspace-images"
```

And then execute:

```bash
$ bundle install
```

## Usage

```ruby
YiffSpace::Images::Avatar.default_for(user.id).url
YiffSpace::Images::Banner.get_for(user.id, :discord).url
```

Configure via:

```ruby
YiffSpace.configure do |config|
  config.images.server_url = "https://images.example.com"
  config.images.update_token = ENV["IMAGES_UPDATE_TOKEN"]
end
```

## Contributing

Go away

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
