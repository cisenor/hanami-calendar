require 'erb'
require_relative '../utility/console_log'

class PrintToERB
  def initialize(template_path, output_path, log = ConsoleLog.new)
    @log = log
    @template = File.read(template_path)
    @output_path = output_path
  rescue IOError
    @log.error "Could not find template file at #{template_path}"
  end

  def render(view_model)
    raise 'No ERB template is loaded.' unless @template
    populated = ERB.new(@template).result(view_model.get_binding)
    File.open(@output_path, 'w+', 0o644) { |file| file.puts populated }
  end
end
