require File.dirname(__FILE__) + '/test_helper'

class StrongPasswordsTest < Test::Unit::TestCase
  def setup
    @user = User.new
  end

  def test_no_password
    assert @user.valid?, @user.errors.full_messages.join(', ')
  end

  def test_failed
    @user.password = "abcdesut"
    assert_equal 1, @user.password_strength
    assert !@user.valid?, @user.errors.full_messages.join(', ')
    assert_password_error "must include at least 3 symbols, numbers, or upper-case letters"
  end

  def test_passed
    @user.password = "abc123EFG"
    assert_equal 4, @user.password_strength
    assert @user.valid?, @user.errors.full_messages.join(', ')
  end

  def test_good_passwords
    ["abcde6^hIJkl",
     "popu!@dD09lqwdqwdwqk",
     "PoPA1dqw0^nqwnd#a"].each do |pw|
      @user.password = pw
      assert @user.valid?, @user.errors.full_messages.join(', ')
    end
  end

  private
  def password_errors
    Array(@user.errors[:password])
  end

  def assert_password_error(str)
    assert password_errors.include?(str), "Password errors didn't include: '#{str}'"
  end
end
