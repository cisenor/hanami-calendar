require_relative '../models/year'
require_relative '../models/calendar_entry_store'
require_relative '../models/formatters/console'
require 'date'

##
# Renders the supplied year class. Each month will be 20
# chars wide. (2 digits * 7 + spacing between each column)
# Header will be 86 characters wide (4 months + 2 chars padding between each)
class ConsoleView
  def initialize(markup_class = FormatConsole, log = ConsoleLog.new)
    @markup = markup_class.new 86
    @h_div = '  '
    @v_div = ' '
    @log = log
  end

  def render(calendar)
    print_calendar calendar
  end

  private

  def write(input)
    puts input
  end

  ##
  # Print the complete calendar to the console.
  def print_calendar(view_model)
    @calendar_entry_store = view_model.calendar_entries
    system 'clear'
    calendar = @markup.title_header(view_model.year)
    calendar << display_months(view_model.months)
    write calendar
    write get_calendar_entries view_model.calendar_entries
  end

  def get_calendar_entries(calendar_entries)
    days = calendar_entries.dates.map(&:to_s)
    imp_dates = @markup.title_header('Important Dates')
    imp_dates << @markup.list(days)
    imp_dates
  end

  def new_line
    puts ''
  end

  def find_longest_month(months)
    sorted_months = months.sort { |x, y| y.weeks.length <=> x.weeks.length }
    sorted_months.first.weeks.length
  end

  def display_weekdays
    wkdy_str = ''
    4.times do
      wkdy_str << 'Su Mo Tu We Th Fr Sa  '
    end
    wkdy_str.rstrip
  end

  def display_months(months)
    calendar = ''
    months.each_slice(4) do |these_months|
      calendar << these_months.map { |month| @markup.month_header(month.name) }.join + "\n"
      calendar << display_weekdays + "\n"
      calendar << get_days(these_months)
      calendar << @v_div * 86 + "\n"
    end
    calendar
  end

  def get_days(months)
    (0...find_longest_month(months)).map do |week_num|
      create_row(week_num, months) + "\n"
    end.join
  end

  def create_row(week_num, months)
    months.map do |month|
      week = month.weeks[week_num]
      next ' ' * 20 + @h_div unless week
      (0..6).map { |day| create_day_entry(week[day]) }.join(' ') + @h_div
    end.join
  end

  def create_day_entry(day)
    return '  ' unless day
    markup = :none
    markup = @calendar_entry_store.styling_tag(day) if @calendar_entry_store
    @markup.style_text(day.day.to_s.rjust(2), markup)
  end
end
