# Formatter for the output to display in the console.
class FormatConsole
  def initialize(line_length)
    @line_length = line_length
    month_spacing = 2
    months_per_row = 4
    @month_width = (line_length - (month_spacing * 3)) / months_per_row
    @highlights = {
      holiday: "\e[1m%<value>s\e[0m",
      leap: "\e[1;32;47m%<value>s\e[0m",
      friday13: "\e[41m%<value>s\e[0m",
      none: '%<value>s'
    }
  end

  def center(text)
    text.center(@line_length)
  end

  def block(text)
    text + "\n"
  end

  def title_header(text)
    block(center(String(text)))
  end

  def month_header(text)
    text.center(@month_width)
  end

  def style_text(text, style)
    output = @highlights.fetch(style, :none)
    format output, value: text
  end

  def list(array)
    array.join("\n")
  end
end
