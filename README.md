# DeepStruct

Utility function to convert a Hash to a Struct. The Hash can be arbitrarily nested, the corresponding
object will have same level of nesting.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deep_struct'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deep_struct

## Usage

```ruby
input = { x: 1, y: { z: 2} }
point = deep_struct(input)
point.x #=> 1
point.y.z #=> 2
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sayantam/deep_struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DeepStruct project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sayantam/deep_struct/blob/master/CODE_OF_CONDUCT.md).
