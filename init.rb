require File.join(File.dirname(__FILE__), 'lib', 'strong_passwords.rb')
::ActiveRecord::Base.send :include, StrongPasswords
