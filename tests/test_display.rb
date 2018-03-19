require 'test/unit'
require_relative '../views/console_view.rb'
require_relative '../views/html_view.rb'
# Class used for testing the month class.
class TestDisplay < Test::Unit::TestCase
  def test_html_display_with_id_and_class
    test = HTMLMarkup.new.get_markup_block('content', 'test-class')
    assumed = '<div class="test-class">content</div>'
    assert_equal assumed, test
  end

  def test_html_display_with_class
    test = HTMLMarkup.new.get_markup_block('content', 'test-class')
    assumed = '<div class="test-class">content</div>'
    assert_equal assumed, test
  end

  def test_html_display_plain_span
    test = HTMLMarkup.new.get_markup_inline('content')
    assumed = '<span>content</span>'
    assert_equal assumed, test
  end

  def test_console_display
    m = ConsoleMarkup.new
    assert_equal "test\n", m.get_markup_block('test')
    assert_equal 'test', m.get_markup_inline('test')
    array = %w[test1 test2 test3]
    assert_equal "test1\ntest2\ntest3\n", m.get_markup_list(array)
  end
end
