require 'rubygems'
require 'test/unit'
require 'active_record'

ENV["RAILS_ENV"] = "test"
 
require File.join(File.dirname(__FILE__), '..', 'lib', 'strong_passwords.rb')
::ActiveRecord::Base.send :include, StrongPasswords
 
class User < ActiveRecord::Base
  validates_strength_of :password, :allow_blank => true
end

ActiveRecord::Base.configurations = {"sqlite3"=>{:adapter=>"sqlite3", :database=>":memory:"}}
ActiveRecord::Base.establish_connection('sqlite3')
 
ActiveRecord::Schema.define :version => 0 do
  create_table :users, :force => true do |t|
    t.column :password, :string
  end
end
