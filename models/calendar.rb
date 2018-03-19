require_relative 'formatters/html'
require_relative 'calendar_entry_store'
require_relative 'year'
# Holds all pertinent calendar data
class Calendar
  attr_reader :calendar_entries
  attr_reader :weekday_headers
  attr_reader :year
  attr_reader :months
  attr_reader :binding
  def initialize(formatter = FormatHTML.new)
    @formatter = formatter
    @weekday_headers = %w[Su Mo Tu We Th Fr Sa]
  end

  def switch_to_year(in_year, config)
    @year_object = Year.new(in_year)
    @year = @year_object.year
    @months = @year_object.months
    @calendar_entries = CalendarEntryStore.new(@year_object)
    add_initial_markup(config)
  end

  def get_style(day)
    style_tag = @calendar_entries.styling_tag(day)
    @formatter.styling(style_tag)
  end

  private

  def add_initial_markup(config)
    config.calendar_entries.each do |entry|
      if entry.date
        d = Date.strptime(@year.to_s + '-' + entry.date, '%Y-%m-%d')
        @calendar_entries.add_calendar_entry(entry.name, d, :holiday)
      else
        begin
          @calendar_entries.calculate_calendar_date(entry.name, entry.month, entry.nth, entry.weekday, :holiday)
        rescue ArgumentError
          raise ArgumentError, "Could not create date from configuration for #{entry.name} on week #{entry.nth}, day #{entry.weekday} of month #{entry.month}"
        end
      end
    end
  end
end
