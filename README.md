# S3x

[![Gem Version](https://badge.fury.io/rb/s3x.svg)](https://badge.fury.io/rb/s3x)
[![Test](https://github.com/ocvit/s3x/workflows/Test/badge.svg)](https://github.com/ocvit/s3x/actions)
[![Coverage Status](https://coveralls.io/repos/github/ocvit/s3x/badge.svg?branch=main)](https://coveralls.io/github/ocvit/s3x?branch=main)

Found something spicy? Want to check it out? Here is the tool for ya 😎

Zero dependencies, no AWS SDK bloat, pure Ruby.

## Installation

Install the gem and add to Gemfile:

```sh
bundle add s3x
```

Or install it manually:

```sh
gem install s3x
```

## Configuration

Initialize a bucket of interest:

```ruby
bucket = S3x::Bucket.new("http://ftp.ruby-lang.org/")
```

You can set `prefix` to pre-filter items and/or override default `page_size`:

```ruby
bucket = S3x::Bucket.new(
  "http://ftp.ruby-lang.org/",
  prefix: "pub/ruby/binaries", # default: nil
  page_size: 666               # default: 1000
)
```

## Usage

Get first X (`page_size`) items:

```ruby
bucket.items
# => [{
#   key:           "pub/media/irb_multiline.mp4",
#   etag:          "03fa58ca64375c23cb567be6b129ab11",
#   size:          239988,
#   storage_class: "INTELLIGENT_TIERING",
#   last_modified: 2019-04-20 09:10:30 UTC
# }, ...]
```

Get next page items:

```ruby
bucket.next_items
# => [{...}, ...]
```

Check if the next page actually exists:

```ruby
bucket.next_items?
# => true/false
```

Get all items in one take:

```ruby
bucket.all_items
# => [{...}, ...]
```

Download selected item using its `key`:

```ruby
bucket.download("pub/misc/ci_versions/cruby-jruby.json")
# => "[\"3.1\",\"3.2\",\"3.3\",\"head\",\"jruby\",\"jruby-head\"]\n"
```

Return bucket name:

```ruby
bucket.name
# => "ftp.r-l.o"
```

## Development

```sh
bin/setup         # install deps
bin/console       # interactive prompt to play around
rake spec         # run tests!
rake spec:no_vcr  # run tests with VCR cassettes disabled!
rake rubocop      # lint code!
rake rubocop:md   # lint docs!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ocvit/s3x.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
