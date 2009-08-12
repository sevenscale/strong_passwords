require File.dirname(__FILE__) + '/test_helper'

class StrongPasswordsScoreTest < Test::Unit::TestCase
  include StrongPasswords::ClassMethods

  def test_all_letters
    assert_equal 1, strong_password_score('abcdefg')
  end

  def test_lower_and_upper
    assert_equal 2, strong_password_score('abcdEFG')
  end

  def test_lower_and_numbers
    assert_equal 2, strong_password_score('abcd123')
  end

  def test_all_numbers
    assert_equal 1, strong_password_score('123456789')
  end

  def test_lower_and_symbol
    assert_equal 2, strong_password_score('abcdefg!')
  end

  def test_lower_and_symbols
    assert_equal 3, strong_password_score('abcdefg!!')
  end

  def test_lower_and_upper_and_symbols
    assert_equal 4, strong_password_score('abcdEFG!!')
  end

  def test_lower_and_upper_and_numbers_and_symbols
    assert_equal 6, strong_password_score('abcdEFG12345!!')
  end
end
