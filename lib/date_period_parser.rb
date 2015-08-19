require "date_period_parser/version"

require 'date'

module DatePeriodParser
  DEFAULT_OFFSET = "+00:00".freeze

  def parse(str, offset = nil)
    Base.new(str, offset).parse
  end

  module_function :parse

  class Base
    attr_reader :value, :offset

    def initialize(value, offset = nil)
      @value  = value.freeze
      @offset = (offset || DEFAULT_OFFSET).freeze
    end

    def parse
      case @value
      when /\Atoday\Z/                then parse_date(Date.today)
      when /\A\d\d\d\d\Z/             then parse_year
      when /\A\d\d\d\d\-\d\d\Z/       then parse_month
      when /\A\d\d\d\d\-\d\d\-\d\d\Z/ then parse_date
      else [nil, nil]
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

    def parse_month
      year, month = @value.split("-")

      first = DateTime.new(year.to_i, month.to_i, 1, 0, 0, 0, offset)
      [
        first,
        last_date_time_of_month(first)
      ]
    end

    def parse_year
      year = @value

      first = DateTime.new(year.to_i, 1,1,0,0,0,offset)
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
