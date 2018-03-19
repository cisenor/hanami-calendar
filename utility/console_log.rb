class ConsoleLog
  def info(text)
    write('INFO', text)
  end

  def warn(text)
    write('WARN', text)
  end

  def error(text)
    write('ERROR', text)
  end

  private

  def write(level, message)
    puts "#{Date.new} [#{level}]: #{message}"
  end
end
