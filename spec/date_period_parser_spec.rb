$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "minitest/autorun"
require 'date_period_parser'

describe DatePeriodParser do
  def parse(str, offset = nil)
    DatePeriodParser.parse(str, offset)
  end

  it '2014' do
    assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  parse("2014").first
    assert_equal DateTime.parse("2014-12-31T23:59:59.999+0000"),  parse("2014").last
  end

  it '2014-01' do
    assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  parse("2014-01").first
    assert_equal DateTime.parse("2014-01-31T23:59:59.999+0000"),  parse("2014-01").last
  end

  it '2014-02' do
    assert_equal DateTime.parse("2014-02-01T00:00:00.000+0000"),  parse("2014-02").first
    assert_equal DateTime.parse("2014-02-28T23:59:59.999+0000"),  parse("2014-02").last

    assert_equal DateTime.parse("2012-02-01T00:00:00.000+0000"),  parse("2012-02").first
    assert_equal DateTime.parse("2012-02-29T23:59:59.999+0000"),  parse("2012-02").last
  end

  it '2014-12' do
    assert_equal DateTime.parse("2014-12-01T00:00:00.000+0000"),  parse("2014-12").first
    assert_equal DateTime.parse("2014-12-31T23:59:59.999+0000"),  parse("2014-12").last
  end

  it '2014-08' do
    assert_equal DateTime.parse("2014-08-01T00:00:00.000+0000"),  parse("2014-08").first
    assert_equal DateTime.parse("2014-08-31T23:59:59.999+0000"),  parse("2014-08").last
  end

  it '2014-01-01' do
    assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  parse("2014-01-01").first
    assert_equal DateTime.parse("2014-01-01T23:59:59.999+0000"),  parse("2014-01-01").last
  end

  it '2014-12-31' do
    assert_equal DateTime.parse("2014-12-31T00:00:00.000+0000"),  parse("2014-12-31").first
    assert_equal DateTime.parse("2014-12-31T23:59:59.999+0000"),  parse("2014-12-31").last
  end

  it 'today' do
    today = Date.today
    assert_equal DateTime.parse("#{today}T00:00:00.000+0000"),  parse("today").first
    assert_equal DateTime.parse("#{today}T23:59:59.999+0000"),  parse("today").last
  end

  describe "with offsets" do
    it '2014' do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0700"),  parse("2014", "+0700").first
      assert_equal DateTime.parse("2014-12-31T23:59:59.999+0700"),  parse("2014", "+0700").last
    end

    it '2014-01' do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0700"),  parse("2014-01", "+7").first
      assert_equal DateTime.parse("2014-01-31T23:59:59.999+0700"),  parse("2014-01", "+7").last
    end

    it '2014-01-01' do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0700"),  parse("2014-01-01", "+7").first
      assert_equal DateTime.parse("2014-01-01T23:59:59.999+0700"),  parse("2014-01-01", "+7").last
    end

    it 'today' do
      today = Date.today
      assert_equal DateTime.parse("#{today}T00:00:00.000+0700"),  parse("today", "+7").first
      assert_equal DateTime.parse("#{today}T23:59:59.999+0700"),  parse("today", "+7").last
    end
  end

  it 'invalid pattern 2014-01-01-01' do
    assert_equal nil,  parse("2014-01-01-01").first
    assert_equal nil,  parse("2014-01-01-01").last
  end

  it 'invalid date 2014-13-01' do
    assert_raises(ArgumentError) do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  parse("2014-13-01").first
    end
    assert_raises(ArgumentError) do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  parse("2014-12-41").first
    end
    assert_raises(ArgumentError) do
      assert_equal DateTime.parse("2014-01-01T00:00:00.000+0000"),  parse("2014-12-41", "+2400").first
    end
  end
end
