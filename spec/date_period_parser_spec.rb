$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "minitest/autorun"
require 'date_period_parser'

describe DatePeriodParser do
  def parse(str, opts = {})
    DatePeriodParser.parse(str, opts)
  end

  it 'parse' do
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014").first
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014", nil).first
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014", {}).first
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014", {offset: nil}).first
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014", {'offset' => nil}).first
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0700"),  parse("2014", {offset: "+0700"}).first
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0700"),  parse("2014", {'offset' => "+0700"}).first
  end

  it '2014' do
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014").first
    assert_equal DateTime.new(2014,12,31, 23, 59, 59.999, "+0000"),  parse("2014").last
  end

  it '2014-01' do
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014-01").first
    assert_equal DateTime.new(2014, 1,31, 23, 59, 59.999, "+0000"),  parse("2014-01").last
  end

  it '2014-02' do
    assert_equal DateTime.new(2014, 2, 1,  0,  0,  0.000, "+0000"),  parse("2014-02").first
    assert_equal DateTime.new(2014, 2,28, 23, 59, 59.999, "+0000"),  parse("2014-02").last

    assert_equal DateTime.new(2012, 2, 1,  0,  0,  0.000, "+0000"),  parse("2012-02").first
    assert_equal DateTime.new(2012, 2,29, 23, 59, 59.999, "+0000"),  parse("2012-02").last
  end

  it '2014-12' do
    assert_equal DateTime.new(2014,12, 1,  0,  0,  0.000, "+0000"),  parse("2014-12").first
    assert_equal DateTime.new(2014,12,31, 23, 59, 59.999, "+0000"),  parse("2014-12").last
  end

  it '2014-08' do
    assert_equal DateTime.new(2014, 8, 1,  0,  0,  0.000, "+0000"),  parse("2014-08").first
    assert_equal DateTime.new(2014, 8,31, 23, 59, 59.999, "+0000"),  parse("2014-08").last
  end

  it '2014-01-01' do
    assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0000"),  parse("2014-01-01").first
    assert_equal DateTime.new(2014, 1, 1, 23, 59, 59.999, "+0000"),  parse("2014-01-01").last
  end

  it '2014-12-31' do
    assert_equal DateTime.new(2014,12,31,  0,  0,  0.000, "+0000"),  parse("2014-12-31").first
    assert_equal DateTime.new(2014,12,31, 23, 59, 59.999, "+0000"),  parse("2014-12-31").last
  end

  it 'today' do
    t = Date.today
    assert_equal DateTime.new(t.year, t.month, t.day, 0, 0, 0.000, "+0000"),  parse("today").first
    assert_equal DateTime.new(t.year, t.month, t.day,23,59,59.999, "+0000"),  parse("today").last
  end

  # https://en.wikipedia.org/wiki/ISO_8601#Week_dates
  it '2015-W01' do
  end

  it '2015-Q1' do
    assert_equal DateTime.new(2015, 1, 1,  0,  0,  0.000, "+0000"),  parse("2015-Q1").first
    assert_equal DateTime.new(2015, 3,31, 23, 59, 59.999, "+0000"),  parse("2015-Q1").last

    assert_equal DateTime.new(2015, 1, 1,  0,  0,  0.000, "-0300"),  parse("2015-Q1", offset: "-0300").first
    assert_equal DateTime.new(2015, 3,31, 23, 59, 59.999, "-0300"),  parse("2015-Q1", offset: "-0300").last
  end

  it 'yesterday' do
    t = Date.today - 1
    assert_equal DateTime.new(t.year, t.month, t.day, 0, 0, 0.000, "+0000"),  parse("yesterday").first
    assert_equal DateTime.new(t.year, t.month, t.day,23,59,59.999, "+0000"),  parse("yesterday").last
  end

  it 'yday' do
    t = Date.today - 1
    assert_equal DateTime.new(t.year, t.month, t.day, 0, 0, 0.000, "+0000"),  parse("yday").first
    assert_equal DateTime.new(t.year, t.month, t.day,23,59,59.999, "+0000"),  parse("yday").last
  end


  it 'ytd' do
    t = DateTime.now
    assert_equal DateTime.new(t.year, 1, 1, 0, 0, 0.000, "+0000"),                        parse("ytd").first
    assert_equal DateTime.new(t.year, t.month, t.day, t.hour,t.minute,t.second, "+0000"), parse("ytd").last

    assert_equal DateTime.new(t.year, 1, 1, 0, 0, 0.000, "+0400"),                        parse("ytd", offset: "+0400").first
    assert_equal DateTime.new(t.year, t.month, t.day, t.hour,t.minute,t.second, "+0400"), parse("ytd", offset: "+0400").last
  end

  it 'mtd' do
    t = DateTime.now
    assert_equal DateTime.new(t.year, t.month, 1, 0, 0, 0.000, "+0000"),                  parse("mtd").first
    assert_equal DateTime.new(t.year, t.month, t.day, t.hour,t.minute,t.second, "+0000"), parse("mtd").last

    assert_equal DateTime.new(t.year, t.month, 1, 0, 0, 0.000, "+0400"),                  parse("mtd", offset: "+0400").first
    assert_equal DateTime.new(t.year, t.month, t.day, t.hour,t.minute,t.second, "+0400"), parse("mtd", offset: "+0400").last
  end

  it 'wtd' do
  end

  it "quarter_of" do
    # private methods
    # from,to = DatePeriodParser::Base.new("foobar").send(:quarter_of, 2015, 1)
  end

  it 'qtd' do
    t = Date.today
    from,to = DatePeriodParser::Base.new("foo").send(:quarter_of, t.year, t.month)

    assert_equal DateTime.new(from.year, from.month, 1, 0, 0, 0.000, "+0000"),                  parse("qtd").first
    assert_equal DateTime.new(to.year, to.month, to.day, to.hour,to.minute,to.second+0.999, "+0000"), parse("qtd").last

    assert_equal DateTime.new(from.year, from.month, 1, 0, 0, 0.000, "+0400"),                  parse("qtd", offset: "+0400").first
    assert_equal DateTime.new(to.year, to.month, to.day, to.hour,to.minute,to.second+0.999, "+0400"), parse("qtd", offset: "+0400").last
  end

  it 'current-month' do
    t = Date.today
    last = t >> 1 # same day, next month
    last = Date.new(last.year, last.month, 1) - 1
    assert_equal DateTime.new(t.year, t.month, 1, 0, 0, 0.000, "+0000"),        parse("current-month").first
    assert_equal DateTime.new(t.year, t.month, last.day,23,59,59.999, "+0000"), parse("current-month").last
  end

  it 'previous-month' do
    t = Date.today << 1
    last = t >> 1 # same day, next month
    last = Date.new(last.year, last.month, 1) - 1
    assert_equal DateTime.new(t.year, t.month, 1, 0, 0, 0.000, "+0000"),        parse("previous-month").first
    assert_equal DateTime.new(t.year, t.month, last.day,23,59,59.999, "+0000"), parse("previous-month").last
  end

  it 'current-year' do
    t = Date.today
    assert_equal DateTime.new(t.year,  1,  1, 0, 0, 0.000, "+0000"), parse("current-year").first
    assert_equal DateTime.new(t.year, 12, 31,23,59,59.999, "+0000"), parse("current-year").last
  end

  it 'previous-year' do
    t = Date.today << 12
    assert_equal DateTime.new(t.year,  1,  1, 0, 0, 0.000, "+0000"), parse("previous-year").first
    assert_equal DateTime.new(t.year, 12, 31,23,59,59.999, "+0000"), parse("previous-year").last
  end

  describe "with offsets" do
    it '2014' do
      assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0700"),  parse("2014", offset: "+0700").first
      assert_equal DateTime.new(2014,12,31, 23, 59, 59.999, "+0700"),  parse("2014", offset: "+0700").last
    end

    it '2014-01' do
      assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0700"),  parse("2014-01", offset: "+7").first
      assert_equal DateTime.new(2014, 1,31, 23, 59, 59.999, "+0700"),  parse("2014-01", offset: "+7").last
    end

    it '2014-01-01' do
      assert_equal DateTime.new(2014, 1, 1,  0,  0,  0.000, "+0700"),  parse("2014-01-01", offset: "+7").first
      assert_equal DateTime.new(2014, 1, 1, 23, 59, 59.999, "+0700"),  parse("2014-01-01", offset: "+7").last
    end

    it 'today' do
      t = Date.today
      assert_equal DateTime.new(t.year, t.month, t.day,  0,  0,  0.000, "+0700"),  parse("today", offset: "+7").first
      assert_equal DateTime.new(t.year, t.month, t.day, 23, 59, 59.999, "+0700"),  parse("today", offset: "+7").last
    end
  end



  it 'invalid pattern 2014-01-01-01' do
    from, to = parse("2014-01-01-01")
    assert_equal nil,  from
    assert_equal nil,  to
    # it is actually nil and not [nil, nil]
    assert_equal nil,  parse("2014-01-01-01")
  end

  it 'invalid date 2014-13-01' do
    assert_raises(ArgumentError) do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  DatePeriodParser.parse!("2014-13-01").first
    end
    assert_raises(ArgumentError) do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  DatePeriodParser.parse!("2014-12-41").first
    end
    assert_raises(ArgumentError) do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  DatePeriodParser.parse!("2014-12-41", offset: "+2400").first
    end
  end
end
