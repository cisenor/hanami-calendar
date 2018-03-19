require_relative 'models/input/console'
require_relative 'views/erb_view'
require_relative 'views/console_view'
require_relative 'models/config/config'
require_relative 'models/config/json_parse'
require_relative 'utility/console_log'
require_relative 'models/calendar'
require 'optparse'

# Main app class.
class App
  def initialize(view)
    @log = ConsoleLog.new
    @user_input = Console.new
    @calendar = Calendar.new
    configure
    template_path = 'views/templates/base_calendar.erb'
    output_path = 'dist/index.html'
    @view = PrintToERB.new(template_path, output_path)
    @view = ConsoleView.new if view == :console
  end

  def main
    prompt_for_year
    print_calendar
    app_loop
  end

  private

  def configure
    @config = Config.new(JSONParser)
    begin
      @config.load_configuration('config.json')
    rescue ArgumentError => arg_error
      @log.error(arg_error.message)
    end
  end

  def app_loop
    loop do
      input = @user_input.prompt_for_action
      break if input == :exit
      process_input input
    end
  end

  ##
  # Prompt the user for a year, then populate the
  # instance vars year and holiday list with the new values
  def prompt_for_year
    @year = @user_input.prompt_for_input('Enter a year:').to_i
    unless @year.between?(1970, 3000)
      puts 'The year must be between 1970 & 3000'
      prompt_for_year
    end
    @calendar.switch_to_year(@year, @config)
  end

  def process_input(input)
    case input
    when :print_calendar then print_calendar
    when :add_calendar_entry then add_calendar_entry
    when :change_year
      prompt_for_year
      print_calendar
    else @log.info 'Invalid input.'
    end
  end

  def add_calendar_entry
    name = @user_input.prompt_for_input('Which holiday would you like to add? ')
    date = @user_input.prompt_for_input('What date does the holiday fall on? (mm-dd format) ')
    d = Date.strptime(date, '%m-%d')
    @calendar.calendar_entries.add_calendar_entry(name, d, :holiday)
    print_calendar
  end

  def print_calendar
    @view.render(@calendar)
  end
end

view = :web
OptionParser.new do |opts|
  opts.on('-C', '--console-only', 'Run in the console only.') do
    view = :console
  end
end.parse!

app = App.new view
app.main
