require 'test/unit'
require_relative '../models/month.rb'

# Class used for testing the month class.
class TestMonth < Test::Unit::TestCase
  def test_month_created
    month = Month.new(2018, 1)
    assert_equal 'January', month.name
    assert_equal 2018, month.year
    assert_equal 31, month.last_day
  end

  def test_weeks_start_mid_week
    month = Month.new(2018, 3)
    week = month.weeks[0]
    assert_equal [nil, nil, nil, nil, Date.new(2018, 3, 1), Date.new(2018, 3, 2), Date.new(2018, 3, 3)], week
  end

  def test_weeks_start_sunday
    month = Month.new(2018, 3)
    week = month.weeks[1]
    assert_equal [
      Date.new(2018, 3, 4),
      Date.new(2018, 3, 5),
      Date.new(2018, 3, 6),
      Date.new(2018, 3, 7),
      Date.new(2018, 3, 8),
      Date.new(2018, 3, 9),
      Date.new(2018, 3, 10)
    ], week
  end

  def test_first_monday_of_month
    month = Month.new(2018, 3)
    assert_equal Date.new(2018, 3, 5), month.nth_weekday_of_month(1, 1)
  end

  def test_third_saturday_of_month
    month = Month.new(2018, 3)
    assert_equal Date.new(2018, 3, 17), month.nth_weekday_of_month(3, 6)
  end

  def test_tenth_monday_of_month
    month = Month.new(2018, 3)
    assert_equal nil, month.nth_weekday_of_month(10, 2)
  end

  ## API tests
  def test_create_weeks_is_internal_only
    month = Month.new(2018, 3)
    assert_raise(NoMethodError) do
      month.create_weeks
    end
    assert_raise(NoMethodError) do
      month.create_first_week
    end
  end
end
