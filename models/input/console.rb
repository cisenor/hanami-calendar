# Any interfacing with the terminal
class Console
  def prompt_for_input(prompt)
    prompt << ' ' unless prompt.end_with? ' '
    print prompt
    gets.chomp
  end

  def prompt_for_action
    print "\nCommands: Print calendar (P), Change year (C),\
     Add a date (A), Exit (X): "
    value = gets.chomp.upcase[0]
    return :nothing unless value
    option(value.to_sym)
  end

  private

  def option(key)
    options = {
      P: :print_calendar,
      C: :change_year,
      V: :print_calendar_dates,
      A: :add_calendar_entry,
      X: :exit
    }
    options.fetch(key, :nothing)
  end
end
