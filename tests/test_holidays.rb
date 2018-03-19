require 'test/unit'
require_relative '../models/calendar_entry_store'

# Class used for testing the month class.
class TestHolidays < Test::Unit::TestCase
  def test_calendar_entry_throws_on_improper_formatted_date
    assert_raise(ArgumentError) do
      CalendarEntry.new('Christmas', 'asd')
    end
  end

  def test_important_date_takes_date
    christmas = Date.new(2018, 12, 25)
    calendar_entry = CalendarEntry.new('Christmas', christmas, :holiday)
    assert_equal 'Christmas - December 25', calendar_entry.to_s
  end

  def test_add_holiday_based_on_week
    calendar_entries = CalendarEntryStore.new(Year.new(2018))
    calendar_entries.calculate_calendar_date('Thanksgiving', 9, 2, 1, :holiday)
    calendar_entries.calculate_calendar_date('Easter', 3, 1, 1, :holiday)
    assert_equal 'Easter - April 2', calendar_entries.dates[0].to_s
    assert_equal 'Thanksgiving - October 8', calendar_entries.dates[1].to_s
  end

  def test_is_holiday
    calendar_entries = CalendarEntryStore.new(Year.new(2018))
    rday = Date.new(2018, 11, 11)
    calendar_entries.add_calendar_entry('Remembrance Day', rday, :holiday)
    assert_equal :holiday, calendar_entries.styling(Date.new(2018, 11, 11))
  end

  def test_is_not_holiday
    calendar_entries = CalendarEntryStore.new(Year.new(2018))
    assert_equal :none, calendar_entries.styling(Date.new(2018, 12, 22))
  end

  def test_holiday_equals
    christmas = Date.new(2018, 12, 25)
    date1 = CalendarEntry.new('Christmas', christmas, :holiday)
    date2 = CalendarEntry.new('Easter', Date.new(2018, 4, 2), :holiday)
    date3 = CalendarEntry.new('Christmas', christmas, :holiday)
    different_name = CalendarEntry.new('Chrimbo', christmas, :holiday)
    assert_not_equal date1, date2
    assert_not_equal date1, different_name
    assert_equal date3, date1
  end

  def test_get_holiday_type
    calendar_entries = CalendarEntryStore.new(Year.new(2000))
    calendar_entries.calculate_calendar_date('Easter', 3, 1, 1, :holiday)
    calendar_entries.calculate_calendar_date('Thanksgiving', 9, 2, 1, :holiday)
    calendar_entries.add_calendar_entry('Remembrance Day', Date.new(2000, 11, 11), :holiday)
    calendar_entries.add_calendar_entry('Christmas Day', Date.new(2000, 12, 25), :holiday)
    calendar_entries.add_calendar_entry('Leap Day', Date.new(2000, 2, 29), :leap)
    calendar_entries.add_calendar_entry('Friday the 13th', Date.new(2000, 10, 13), :friday13)
    assert_equal 'Calendar Entry Store containing 6 entries', calendar_entries.to_s
    assert_equal :leap, calendar_entries.styling(Date.new(2000, 2, 29))
    assert_equal :friday13, calendar_entries.styling(Date.new(2000, 10, 13))
    assert_equal :holiday, calendar_entries.styling(Date.new(2000, 12, 25))
    assert_equal :none, calendar_entries.styling(Date.new(2000, 1, 24))
  end
end
