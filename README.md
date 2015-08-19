![build](https://travis-ci.org/hasclass/date_period_parser.svg?branch=master)

# DatePeriodParser

Parse a date-like string and returns it's start and end DateTime.

This can be used to pass date-periods for URL parameters or query strings, e.g. filtering records in a given period.

```ruby
# Example useage in a rails controller

class PostsController
  # GET /posts?period=2015-08
  def index
    date_range = DatePeriodParser.range(params["period"])
    # with user specific timezones
    # date_range = DatePeriodParser.range(params["period"], offset: current_user.timezone)
    date_range ||= DatePeriodParser.range("current-month") # default
    @posts = Posts.where(created_at: date_range)
  end
end
```

It is **not** a natural language date parser like the [chronic gem](https://github.com/mojombo/chronic). But intends to parse common formats like [ISO_8601](https://en.wikipedia.org/wiki/ISO_8601).

Examples:

* years  `YYYY`
* months `YYYY-MM`
* dates  `YYYY-MM-DD`
* beginning of year/month to now `ytd`, `mtd`
* shorcuts `today`, `yesterday` and `yday`, `current-month`, `previous-month`, `current-year`, `previous-year`


Tested with all common Rubies, 1.9.3 .. 2.2, JRuby (1.9 mode). For details check .travis.yml

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
DatePeriodParse.parse("2014-12-31", offset: "+0700")
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

## Recognized patterns

Values below for today: 2015-07-14 15:33

| Pattern            | From             | Until            |
|--------------------|------------------|------------------|
| 2015               | 2015-01-01 00:00 | 2015-12-31 23:59 |
| ytd                | 2015-01-01 00:00 | 2015-07-14 15:33 |
| current-year       | 2015-01-01 00:00 | 2015-07-31 23:59 |
| previous-year      | 2014-01-01 00:00 | 2014-12-31 23:59 |
| 2015-07            | 2015-07-01 00:00 | 2015-07-31 23:59 |
| mtd                | 2015-07-01 00:00 | 2015-07-14 15:33 |
| current-month      | 2015-07-01 00:00 | 2015-07-31 23:59 |
| previous-month     | 2015-06-01 00:00 | 2015-06-30 23:59 |
| 2015-12-31         | 2015-12-31 00:00 | 2015-12-31 23:59 |
| today              | 2015-07-14 00:00 | 2015-07-14 23:59 |
| yesterday          | 2015-07-13 00:00 | 2015-07-13 23:59 |

Difference between `ytd` and `current-year` (`mtd` and `current-month` respectively) is that `ytd` will return DateTime.now vs. current-month spans from first to last day of the month.

### DatePeriodParser.parse

```ruby
from,until = DatePeriodParser.parse("2014")
from # => #<DateTime 2014-01-01T00:00:00.000+0000")
until   # => #<DateTime 2014-12-31T23:59:59.999+0000")

# offsets:
from,until = DatePeriodParser.parse("2014", offset: "+0700")
from # => #<DateTime 2014-01-01T00:00:00.000+0700")
until   # => #<DateTime 2014-12-31T23:59:59.999+0700")

# invalid periods
DatePeriodParser.parse("123213")
# => nil

# so you can do:
from,until = DatePeriodParser.parse("123213")
from  ||= DateTime.yesterday
until ||= DateTime.now

# parse! raises ArgumentError for invalid periods
from,until = DatePeriodParser.parse("123213")
#=> ArgumentError
```

### DatePeriodParser.range

Works the same as DatePeriodParser.parse but returns a range.

```ruby
rng = DatePeriodParser.range("2014")
rng.member? DateTime.new(2014,8,6)

# invalid periods return nil
rng = DatePeriodParser.range("dsf89sfd")
# => nil

# range! raises ArgumentError for invalid periods
rng = DatePeriodParser.range("dsf89sfd")
#=> ArgumentError
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hasclss/date_period_parser.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

