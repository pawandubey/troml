# frozen_string_literal: true

require "test_helper"
# require "date"

# Borrowed from jm/toml
# https://github.com/jm/toml/blob/e8b11e241a9e622f52ad759aff4ffa588b73071c/test/test_parser.rb
class TestSpec < Minitest::Test
  def setup
    @raw = File.read(File.join(File.dirname(__FILE__), "data", "spec.toml"))
    @parsed = Troml.parse(@raw)
  end

  def test_string
    assert_equal "string\n\t\"string", @parsed["strings"]["string"]
    assert_equal "", @parsed["strings"]["empty"]
  end

  def test_integer
    assert_equal 42, @parsed["ints"]["simple"]
  end

  def test_negative_integer
    assert_equal(-42, @parsed["ints"]["negative"])
  end

  def test_underscored_integer
    assert_equal 230_0_0, @parsed["ints"]["simple_underscored"]
    assert_equal 10_000_000_010, @parsed["ints"]["long_underscored"]
  end

  def test_negative_underscored_integer
    assert_equal(-10_0_0, @parsed["ints"]["negative_underscored"])
  end

  def test_float
    assert_equal 3.14159, @parsed["floats"]["pi"]
  end

  def test_negative_float
    assert_equal(-10.0, @parsed["floats"]["negative"])
  end

  def test_underscored_float
    assert_equal 300.14159, @parsed["floats"]["underscored_pi"]
  end

  def test_negative_underscored_float
    assert_equal(-10.09, @parsed["floats"]["underscored_negative"])
  end

  def test_datetime
    assert_equal DateTime.iso8601("1979-05-27T07:32:00Z"), @parsed["datetimes"]["simple"]
  end

  def test_booleans
    assert_equal true, @parsed["true"]
    assert_equal false, @parsed["false"]
  end

  def test_simple_array
    assert_equal [1, 2, 3], @parsed["arrays"]["simple"]
  end

  def test_nested_array
    assert_equal [[1, 2], [3]], @parsed["arrays"]["nested"]
  end

  def test_empty_array
    assert_equal [], @parsed["arrays"]["empty"]
  end

  def test_empty_multiline_array
    assert_equal [], @parsed["arrays"]["multiline_empty"]
  end

  def test_empty_multiline_array_with_comment
    assert_equal [], @parsed["arrays"]["multiline_empty_comment"]
  end

  def test_multiline_arrays
    assert_equal ["lines", "are", "super", "cool", "lol", "amirite"], @parsed["arrays"]["multi"]
  end

  def test_multiline_array
    assert_equal @parsed["arrays"]["multiline"], [1, 2, 3]
  end

  def test_multiline_array_with_trailing_comma
    assert_equal @parsed["arrays"]["multiline_trailing_comma"], [1, 2, 3]
  end

  def test_multiline_array_with_comments
    assert_equal @parsed["arrays"]["multiline_comments"], [1, 2, 3]
  end

  def test_simple_keygroup
    assert_equal "test", @parsed["e"]["f"]
  end

  def test_nested_keygroup
    assert_equal "test", @parsed["a"]["b"]["c"]["d"]
  end

  def test_inline_comment
    assert_equal "a line", @parsed["comments"]["on"]
  end

  def test_bare_key_with_comment_prefixed
    assert_nil @parsed["comments"]["#nospacecomment"]
  end
end
