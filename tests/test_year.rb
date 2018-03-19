require 'test/unit'
require_relative '../models/year.rb'

# Test cases for the year class
class TestYear < Test::Unit::TestCase
  def test_year_creation
    y = Year.new(2001)
    assert_equal y.months.length, 12
    assert_equal 'February', y.months[1].name
    assert_equal 28, y.months[1].last_day
  end

  def test_leap_year
    no_leap = Year.new(2001)
    leap = Year.new(2000)
    assert_equal false, no_leap.leap_year?
    assert_equal 28, no_leap.months[1].last_day
    assert_equal true, leap.leap_year?
    assert_equal 29, leap.months[1].last_day
  end
end
