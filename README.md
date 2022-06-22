# Troml

> ⚠ Alpha quality software. Consider it a side project and read the [gotchas](#current-gotchas).

Blazing fast [TOML](https://toml.io) parsing, with the power of Rust ⚡

Troml utilizes [`rutie`](https://github.com/danielpclark/rutie) to parse TOML by delegating the actual parsing to Rust-land. The Rust code uses the canonical [`toml`](https://github.com/alexcrichton/toml-rs) package that's also used by Cargo.

As of June 2022, Troml is approximately 30 _thousand_ times faster than the `toml` ruby gem at parsing the `test/data/spec.toml` file in this repository, as measured on a Thinkpad T470 with Intel Core i7-7500U @ 4x 3.5GHz and 12GB of RAM running KDE Neon 20.04.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add troml

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install troml

## Usage

```ruby
# Parse TOML strings with Troml.parse
Troml.parse("foo='bar'")
# => {"foo"=>"bar"}

# Read and parse the contents of a file with
Troml.parse_file("path/to/file.toml")
```

## Current Gotchas
- Troml only deserializes TOML documents, it does not generate them.
- Troml uses `rutie`, which at this time has a bug where [it leaks memory when it tries to `raise` in Ruby from Rust](https://github.com/danielpclark/rutie/issues/159). Troml raises on parse failures currently. This means that if you are encountering a lot of parse failures, your program will end up consuming a lot of memory. I have a fix for this in mind and will implement it soon.
- Troml packaging depends on the Cargo extension builder toolchain in Rubygems. As that is a recently-shipped feature, there might be bugs in the packaging of this gem.

## Performance

The benchmark is located in `bin/benchmark`. Here is a sample benchmark run from my laptop:

```
★ 𝞴 date
Wed 22 Jun 2022 12:56:22 AM EDT
 pawan  : [ruby-3.1.2] : [troml] on main *%
★ 𝞴 bin/benchmark
Warming up --------------------------------------
             jm/toml     5.666B i/100ms
               troml     1.091T i/100ms
Calculating -------------------------------------
             jm/toml    233.632B (±26.6%) i/s -      1.065T in   5.008150s
               troml      9.958Q (±18.5%) i/s -     46.181Q in   4.967881s

Comparison:
               troml: 9957828005865654.0 i/s
             jm/toml: 233631820362.5 i/s - 42621.88x  (± 0.00) slower
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pawandubey/troml. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pawandubey/troml/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Troml project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pawandubey/troml/blob/master/CODE_OF_CONDUCT.md).
