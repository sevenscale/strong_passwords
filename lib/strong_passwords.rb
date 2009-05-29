module StrongPasswords
  def self.included(base)
    base.extend StrongPasswords::ClassMethods
  end

  VALID_SYMBOLS = "\!\@\#\$\%\^\&\*\_\-"

  module ClassMethods

    # Validates an attribute as a strong password.
    #
    #   class User < ActiveRecord::Base
    #     validates_strength_of :password, :allow_blank => true
    #   end
    #
    # Any options for validates_length_of and validates_format_of
    # will be passed along to the other validations.
    def validates_strength_of(attr,opts={ })
      validates_length_of attr, opts.merge(:minimum => 12)
      validates_format_of attr, opts.merge(:with => /[#{VALID_SYMBOLS}]/, :message => "must include at least 1 symbol (#{VALID_SYMBOLS})")
      validates_format_of attr, opts.merge(:with => /\d/, :message => "must include at least 1 number")
      validates_format_of attr, opts.merge(:with => /[A-Z]/, :message => "must include at least 1 upper-case letter")
      validates_format_of attr, opts.merge(:with => /[a-z]/, :message => "must include at least 1 lower-case letter")
    end
  end
end
