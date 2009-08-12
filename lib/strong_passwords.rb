module StrongPasswords
  def self.included(base)
    base.extend StrongPasswords::ClassMethods
  end

  VALID_SYMBOLS = '!@#$%^&*()[]{}?+|"\'\\/.,:;'

  module ClassMethods
    PASSWORD_TESTS = [
      /[#{Regexp.escape(VALID_SYMBOLS)}]/, # Give them a point for each symbol they use
      /\d+/,                               # Give them a point for using numbers
      /[a-zA-Z]+/,                         # Give them a point for using letters
      /[a-z].*?[A-Z]|[A-Z].*[a-z]/,        # Give them a point for every upper-to-lower or lower-to-upper
      /.{10}/                              # Give them an extra point every 10 characters
    ]

    # Validates an attribute as a strong password.
    #
    #   class User < ActiveRecord::Base
    #     validates_strength_of :password, :allow_blank => true
    #   end
    #
    # Any options for validates_length_of and validates_format_of
    # will be passed along to the other validations.
    def validates_strength_of(*attrs)
      options = attrs.extract_options!.symbolize_keys
      attrs   = attrs.flatten

      minimum_score = options.delete(:score) || 3

      attrs.each do |attr|
        define_method("#{attr}_strength") do
          self.class.strong_password_score(self[attr])
        end
      end

      validates_each(attrs, options) do |record, attr, value|
        if strong_password_score(value) < minimum_score
          record.errors.add(attr, "must include at least #{minimum_score} symbols, numbers, or upper-case letters")
        end
      end
    end

    def strong_password_score(value)
      score = PASSWORD_TESTS.sum do |regexp|
        value.to_s.scan(regexp).length
      end
    end
  end
end
