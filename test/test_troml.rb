# frozen_string_literal: true

require "test_helper"

class TestTroml < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Troml::VERSION
  end

  def test_empty
    assert_equal({}, Troml.parse(""))
  end

  def test_key_val
    assert_equal({"foo" => "bar"}, Troml.parse("foo = 'bar'"))
  end

  def test_failure
    skip # TODO: Fix error handling in the rust extension
    Troml.parse("abc*123(")
  end
end
