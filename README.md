# DatePeriodParser

Parse a date-like string and returns it's start and end DateTime.

This can be used to pass date-periods for URL parameters or query strings, e.g. filtering records in a given period.

It is *not* meant to be a natural language date parser like the [https://github.com/mojombo/chronic](chronic gem).

## Examples

```ruby
# year
DatePeriodParse.parse("2014")
#=> [<#DateTime 2014-01-01T00:00:00.000Z>, <#DateTime 2014-12-31T23:59:59.999Z>]

# months
DatePeriodParse.parse("2014-02")
#=> [<#DateTime 2014-02-01T00:00:00.000Z>, <#DateTime 2014-02-28T23:59:59.999Z>]

# day
DatePeriodParse.parse("2014-12-31")
#=> [<#DateTime 2014-12-31T00:00:00.000Z>, <#DateTime 2014-12-31T23:59:59.999Z>]

DatePeriodParse.parse("today")
#=> [<#DateTime 2015-08-31T00:00:00.000Z>, <#DateTime 2014-08-31T23:59:59.999Z>]

# timezone offsets
DatePeriodParse.parse("2014-12-31", "+0700")
#=> [<#DateTime 2014-12-31T00:00:00.000+0700>, <#DateTime 2014-12-31T23:59:59.999+0700>]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'date_period_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install date_period_parser

## Usage

See examples above. Currently supported are:

* years  "2014"
* months "2014-01"
* dates  "2014-01-01"
* shorcuts "today"

It currently requires the year to have 4 digits.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hasclss/date_period_parser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

