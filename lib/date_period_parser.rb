require "date_period_parser/version"

require 'date'

module DatePeriodParser
  DEFAULT_OFFSET = "+00:00".freeze

  # ## Useage
  #
  #     from,until = DatePeriodParser.parse("2014")
  #     from # => #<DateTime 2014-01-01T00:00:00.000+0000")
  #     until   # => #<DateTime 2014-12-31T23:59:59.999+0000")
  #
  #     # offsets:
  #     from,until = DatePeriodParser.parse("2014", "+0700")
  #     from # => #<DateTime 2014-01-01T00:00:00.000+0700")
  #     until   # => #<DateTime 2014-12-31T23:59:59.999+0700")
  #
  #     # invalid periods
  #     DatePeriodParser.parse("123213") # => nil
  #     from,until = DatePeriodParser.parse("123213")
  #     from # => nil
  #     until # => nil
  #
  #
  #
  def parse(str, offset = nil)
    parse!(str, offset)
  rescue ArgumentError => e
    nil
  end

  def parse!(str, offset = nil)
    Base.new(str, offset).parse
  end

  def range(str, offset = nil)
    range!(str, offset)
  rescue ArgumentError => e
    nil
  end

  def range!
    first,last = Base.new(str, offset).parse
    first..last
  end

  module_function :parse, :parse!, :range, :range!

  class Base
    attr_reader :value, :offset

    def initialize(value, offset = nil)
      @value  = value.freeze
      @offset = (offset || DEFAULT_OFFSET).freeze
    end

    def parse
      case @value
      when /\Atoday\Z/                then parse_date(Date.today)
      when /\Ayesterday\Z/            then parse_date(Date.today - 1)
      when /\Ayday\Z/                 then parse_date(Date.today - 1)
      when /\Acurrent-month\Z/        then parse_month(Date.today)
      when /\Aprevious-month\Z/       then parse_month(Date.today << 1)
      when /\Acurrent-year\Z/        then parse_year(Date.today)
      when /\Aprevious-year\Z/       then parse_year(Date.today << 12)
      when /\A\d\d\d\d\Z/             then parse_year
      when /\A\d\d\d\d\-\d\d\Z/       then parse_month
      when /\A\d\d\d\d\-\d\d\-\d\d\Z/ then parse_date
      else raise ArgumentError.new("invalid date period")
      end
    end

  protected

    def parse_date(date = nil)
      if date.nil?
        year, month, day = @value.split("-").map(&:to_i)
      else
        year, month, day = date.year, date.month, date.day
      end

      date = DateTime.new(year, month, day, 0, 0, 0, offset)

      [
        date,
        end_of_date(date)
      ]
    end

    def parse_month(date = nil)
      if date.nil?
        year, month = @value.split("-").map(&:to_i)
      else
        year, month = date.year, date.month
      end

      first = DateTime.new(year, month, 1, 0, 0, 0, offset)
      [
        first,
        last_date_time_of_month(first)
      ]
    end

    def parse_year(date = nil)
      if date.nil?
        year = @value.to_i
      else
        year = date.year
      end

      first = DateTime.new(year, 1,1,0,0,0,offset)
      [
        first,
        last_date_time_of_month(first >> 11)
      ]
    end

    def last_date_time_of_month(dt)
      first_day_this_month = DateTime.new(dt.year, dt.month, 1, 0, 0, 0, offset)
      first_day_next_month = first_day_this_month >> 1
      last_day_this_month  = first_day_next_month - 1

      d = last_day_this_month
      end_of_date(d)
    end

    def end_of_date(dt)
      DateTime.new(dt.year, dt.month, dt.day, 23, 59, 59.999, offset)
    end
  end
end
