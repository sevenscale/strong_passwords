require File.dirname(__FILE__) + '/test_helper'

class StrongPasswordsTest < Test::Unit::TestCase
  def setup
    @user = User.new
  end

  def password_errors
    @user.errors[:password].is_a?(Array) ? @user.errors[:password] : [@user.errors[:password]]
  end

  def assert_password_error(str)
    assert password_errors.include?(str), "Password errors didn't include: '#{str}'"
  end

  def test_no_password
    assert @user.valid?
  end

  def test_too_short
    @user.password = "abcde"
    assert !@user.valid?
    assert_password_error "is too short (minimum is 12 characters)"
  end

  def test_symbols
    @user.password = "abcdefghijklmopqrtsut"
    assert !@user.valid?
    assert_password_error "must include at least 1 symbol (#{StrongPasswords::VALID_SYMBOLS})"
  end

  def test_numbers
    @user.password = "abcdefghijklmopqrtsut"
    assert !@user.valid?
    assert_password_error "must include at least 1 number"
  end

  def test_upper_case
    @user.password = "abcdefghijklmopqrstuv"
    assert !@user.valid?
    assert_password_error "must include at least 1 upper-case letter"
  end

  def test_lower_case
    @user.password = "ABCDEFGHIJKLMNOPQRSTUV"
    assert !@user.valid?
    assert_password_error "must include at least 1 lower-case letter"
  end

  def test_good_passwords
    ["abcde6^hIJkl",
     "popu!@dD09lqwdqwdwqk",
     "PoPA1dqw0^nqwnd#a"].each do |pw|
      @user.password = pw
      assert @user.valid?
    end
  end
end
