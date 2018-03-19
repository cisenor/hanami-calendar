require 'test/unit'
require_relative '../views/console_view.rb'
require_relative '../views/html_view.rb'
# Class used for testing the month class.
class TestFileIO < Test::Unit::TestCase
  def test_file_write
    filename = 'testing.html'
    display = HTMLView.new filename
    display.send(:initialize_new_file)
    display.write('testing')
    File.open('dist/' + filename, 'r') do |file| 
      assert_equal "<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\"></head><body>\n", file.gets
      assert_equal "testing\n", file.gets
    end
    File.delete('dist/' + filename)
  end

  def test_write_file_fails_when_not_opened
    filename = 'testing'
    display = HTMLView.new filename
    assert_raise IOError do
      display.send(:write, 'SuperTestMessage')
    end
  end
end
