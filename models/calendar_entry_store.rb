require 'date'

##
# Object that holds all calendar entry objects
class CalendarEntryStore
  attr_reader :dates
  def initialize(year)
    @dates = []
    raise ArgumentError, "Year parameter must be of type Year, got #{year.class}" unless year.class == Year
    @year = year
    check_for_friday_thirteenth
    check_for_leap
  end

  ##
  # Creates a holiday based on the nth weekday of the month.
  def calculate_calendar_date(name, month, occurrence, weekday, type)
    selected_month = @year.months[month]
    day = selected_month.nth_weekday_of_month(occurrence, weekday)
    add_calendar_entry(name, day, type)
  end

  ##
  # Create a new calendar entry and add it to the store.
  def add_calendar_entry(name, date, type)
    raise ArgumentError unless date.class == Date
    entry = CalendarEntry.new(name, date, type)
    return if @dates.include? entry
    # We're good
    @dates << entry
    @dates.sort!
  rescue StandardError
    puts "Can't create holiday with provided date: #{date}"
  end

  ##
  # Get the styling key for the provided date
  def styling_tag(date)
    day = get_calendar_entry_by_date date
    return day.type if day
    :none
  end

  def to_s
    "Calendar Entry Store containing #{dates.length} entries"
  end

  private

  def check_for_leap
    return unless @year.leap_year?
    leap_day = Date.new(@year.year, 2, 29)
    add_calendar_entry('Leap Day', leap_day, :leap)
  end

  def check_for_friday_thirteenth
    @year.months.each do |month|
      month.weeks.each do |week|
        day = week[5]
        next unless day && day.day == 13
        add_calendar_entry('Friday the 13th', day, :friday13)
      end
    end
  end

  def get_calendar_entry_by_date(date)
    @dates.find { |d| d.date == date }
  end

  def date_has_entry?(date)
    @dates.include? { |h| h.date == date }
  end
end

# A single entry object
class CalendarEntry
  attr_reader :name
  attr_reader :date
  attr_reader :type
  def initialize(name, date, type)
    @name = name
    raise ArgumentError unless date.class == Date
    @date = date
    @type = type
  end

  def ==(other)
    @date == other.date && @name == other.name
  end

  def <=>(other)
    @date <=> other.date
  end

  def to_s
    "#{@name} - #{@date.strftime('%B %-d')}"
  end
end
