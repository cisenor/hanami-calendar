require 'test/unit'
require_relative '../models/config'
require_relative '../models/json_parse'
# Class used for testing the month class.
class TestConfig < Test::Unit::TestCase
  def test_can_read_config
    config = Config.new(JSONParser)
    config.load_configuration('./config.json')
    assert_not_nil config.calendar_entries
  end

  def test_ioerror_when_file_doesnt_exist
    config = Config.new(JSONParser)
    assert_raise(IOError) do
      config.load_configuration('./fakeconfig.txt')
    end
  end

  def test_parses_calendar_entries_properly
    config = Config.new(JSONParser)
    config.load_configuration('./tests/config.json')
    assert_equal 3, config.calendar_entries.size
    assert_equal 'Christmas', config.calendar_entries[0].name
    assert_equal 'Easter', config.calendar_entries[1].name
  end

  def test_raises_argument_error_on_invalid_config
    config = Config.new(JSONParser)
    assert_raise(ArgumentError) do
      config.load_configuration('./tests/broken_config.json')
    end
  end
end
