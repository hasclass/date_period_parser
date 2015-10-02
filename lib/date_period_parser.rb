require "date_period_parser/version"

require 'date'

module DatePeriodParser
  DEFAULT_OFFSET = "+00:00".freeze

  # Returns array of start and end DateTime of given period string.
  #
  # @example Basic useage
  #     DatePeriodParser.parse("2014")
  #     # => [
  #     #   #<DateTime 2014-01-01T00:00:00.000+0000">,
  #     #   #<DateTime 2014-12-31T23:59:59.999+0000">
  #     # ]
  #
  # @example with timezone offsets:
  #     from,until = DatePeriodParser.parse("2014", offset: "+0700")
  #     from    # => #<DateTime 2014-01-01T00:00:00.000+0700">
  #     until   # => #<DateTime 2014-12-31T23:59:59.999+0700">
  #
  # @example invalid periods
  #     DatePeriodParser.parse("123213") # => nil
  #     from,until = DatePeriodParser.parse("123213")
  #     from    # => nil
  #     until   # => nil
  #
  # @param  [String] period date period string.
  # @option options [String] :offset ("+0000") timezone offset, e.g. "+0700"
  # @option options [String] :default (nil) use this default if `period` is nil
  # @return [Array<DateTime, DateTime>] start and end DateTime
  # @return [nil] if period string is invalid
  #
  def parse(period, options = {})
    parse!(period, options)
  rescue ArgumentError => e
    nil
  end

  # Same as #parse but raises an ArgumentError if period string is invalid
  #
  # @example Basic useage
  #     def my_method
  #       from,until = DatePeriodParser.parse!("FOOBAR")
  #     rescue ArgumentError => e
  #        # do something
  #     end
  #
  # @see #parse
  # @param  [String] period date period string.
  # @raise [ArgumentError] if period string is invalid
  # @option options [String] :offset ("+0000") timezone offset, e.g. "+0700"
  # @option options [String] :default (nil) use this default if `period` is nil
  # @return [Array<DateTime, DateTime>] start and end DateTime
  #
  def parse!(period, options = {})
    period = options[:default] if period.nil? || period.empty?
    Base.new(period, options).parse
  end

  # Same as #parse but returns a range instead
  #
  # @example Basic useage
  #     rng = DatePeriodParser.range("2014")
  #     rng.member? DateTime.new(2014,8,6)
  #
  # @see #parse
  # @param  [String] period date period string.
  # @raise [ArgumentError] if period string is invalid
  # @option options [String] :offset ("+0000") timezone offset, e.g. "+0700"
  # @option options [String] :default (nil) use this default if `period` is nil
  # @return [Range<DateTime, DateTime>] start and end DateTime as range
  #
  def range(period, options = {})
    range!(period, options)
  rescue ArgumentError => e
    nil
  end

  # Same as #range but raises an ArgumentError if period string is invalid
  #
  # @example Basic useage
  #     def my_method
  #       rng = DatePeriodParser.range!("FOOBAR")
  #     rescue ArgumentError => e
  #        # do something
  #     end
  #
  # @see #parse
  # @param  [String] period date period string.
  # @raise [ArgumentError] if period string is invalid
  # @option options [String] :offset ("+0000") timezone offset, e.g. "+0700"
  # @option options [String] :default (nil) use this default if `period` is nil
  # @return [Range<DateTime, DateTime>] start and end DateTime as range
  #
  def range!(period, options = {})
    period = options[:default] if period.nil? || period.empty?
    first,last = Base.new(period, options).parse
    first..last
  end

  module_function :parse, :parse!, :range, :range!

  # @api private
  class Base
    attr_reader :value, :offset

    def initialize(value, options = nil)
      options ||= {} # in case someone sends Base.new("", nil)
      @value    = value.to_s.freeze
      @offset = (options[:offset] || options['offset'] || DEFAULT_OFFSET).freeze
    end

    def parse
      case @value
      when /\Atoday\Z/i                then parse_date(Date.today)
      when /\Ayesterday\Z/i            then parse_date(Date.today - 1)
      when /\Ayday\Z/i                 then parse_date(Date.today - 1)
      when /\Acurrent-month\Z/i        then parse_month(Date.today)
      when /\Aprevious-month\Z/i       then parse_month(Date.today << 1)
      when /\Acurrent-year\Z/i         then parse_year(Date.today)
      when /\Aprevious-year\Z/i        then parse_year(Date.today << 12)
      when /\Amtd\Z/i                  then mtd
      when /\Aqtd\Z/i                  then quarter_of(Date.today.year, Date.today.month)
      when /\Aytd\Z/i                  then ytd
      when /\A\d\d\d\d\-Q\d\Z/i        then parse_quarter
      when /\A\d\d\d\d\Z/i             then parse_year
      when /\A\d\d\d\d\-\d\d\Z/i       then parse_month
      when /\A\d\d\d\d\-\d\d\-\d\d\Z/i then parse_date
      else raise ArgumentError.new("invalid date period")
      end
    end

  protected
    def quarter_of(year, month)
      case month
      when  1..3  then [start_of_date(Date.new(year,  1)), end_of_date(Date.new(year,  3, 31))]
      when  4..6  then [start_of_date(Date.new(year,  4)), end_of_date(Date.new(year,  6, 30))]
      when  7..9  then [start_of_date(Date.new(year,  7)), end_of_date(Date.new(year,  9, 30))]
      when 10..12 then [start_of_date(Date.new(year, 10)), end_of_date(Date.new(year, 12, 31))]
      else
        raise ArgumentError.new("invalid date period")
      end
    end

    def now_with_offset
      d = DateTime.now
      DateTime.new(d.year, d.month, d.day, d.hour, d.minute, d.second, offset)
    end

    def mtd
      now = now_with_offset
      [
        DateTime.new(now.year, now.month, 1, 0, 0, 0, offset),
        now
      ]
    end

    def ytd
      now = now_with_offset
      [
        DateTime.new(now.year, 1, 1, 0, 0, 0, offset),
        now
      ]
    end

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

    def parse_quarter
      year, quarter = @value.upcase.split("-Q").map(&:to_i)

      quarter_of(year, (quarter - 1) * 3 + 1)
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

    def start_of_date(dt)
      DateTime.new(dt.year, dt.month, dt.day, 0,  0,  0, offset)
    end

    def end_of_date(dt)
      DateTime.new(dt.year, dt.month, dt.day, 23, 59, 59.999, offset)
    end
  end
end
