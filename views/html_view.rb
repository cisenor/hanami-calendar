require 'date'
require_relative '../models/year.rb'
require_relative './console_view'
require_relative '../models/calendar_entry_store.rb'

##
# Outputs provided year's calendar to an HTML file.
class HTMLView
  ##
  # +filename+ Name of the output file, located in the dist folder.
  def initialize(filename, markup_class = HTMLMarkup)
    @markup = markup_class.new
    @filename = 'dist/' + filename
  end

  ##
  # Prints the calendar to the HTML file, highlighting
  # any days that are also stored in the calendar entry store.
  def print_calendar(year, calendar_entry_store = nil)
    @calendar_entry_store = calendar_entry_store
    raise ArgumentError 'Year must be a Year object.' if year.class != Year
    initialize_new_file
    write @markup.get_markup_block(year.year, 'centered header')
    write @markup.get_markup_block(create_months(year.months), 'container')
    write get_calendar_entries
    write @markup.end
  end

  ##
  # Logs text to the console, not to the HTML file.
  def log(text)
    puts text
  end

  ##
  # Writes provided text to the initialized text file.
  def write(text)
    raise IOError, 'The file has not yet been initialized' unless File.file? @filename
    File.open(@filename, 'a') { |file| file.puts text }
  end

  ##
  # Render all holidays as name - date
  def log_calendar_entries(calendar_entries = nil)
    log get_calendar_entries(calendar_entries)
  end

  private

  def get_calendar_entries(calendar_entries = nil)
    @calendar_entry_store = calendar_entries if calendar_entries
    days = @calendar_entry_store.dates.map(&:to_s)
    imp_dates = @markup.get_markup_block('Important Dates', 'header centered')
    imp_dates << @markup.get_markup_list(days)
    imp_dates
  end

  def create_months(months)
    months.map do |this_month|
      month_str = @markup.get_markup_block(this_month.name, 'month-name')
      month_str << week_header
      month_str << create_weeks(this_month)
      @markup.get_markup_block(month_str, 'month')
    end.join
  end

  # Create the day element. Either a 1-2 digit number with appropriate markup
  # or an empty span element
  def create_day_entry(day)
    return @markup.get_markup_inline(' ') unless day
    markup = :none
    markup = @calendar_entry_store.styling(day) if @calendar_entry_store
    @markup.highlight(day.day, markup)
  end

  def week_header
    weekdays = %w[Su Mo Tu We Th Fr Sa]
    header_str = weekdays.map { |day| @markup.get_markup_inline(day) }.join
    @markup.get_markup_block(header_str, 'week-header')
  end

  def create_weeks(month)
    month.weeks.map do |week|
      week_str = (0..6).map { |day| create_day_entry(week[day]) }.join
      @markup.get_markup_block(week_str, 'week')
    end.join
  end

  def initialize_new_file
    File.open(@filename, 'w+', 0o644) { |file| file.puts @markup.start }
  end
end
