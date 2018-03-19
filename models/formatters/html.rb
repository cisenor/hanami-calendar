class FormatHTML
  def initialize
    @highlights = {
      holiday: 'bold',
      leap: 'leap-day',
      friday13: 'friday-13',
      none: ''
    }
  end

  def styling(style)
    @highlights.fetch(style, '')
  end
end
