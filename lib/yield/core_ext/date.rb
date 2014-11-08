require File.dirname(__FILE__) + '/date/calculations'

class Date #:nodoc:
  include Yield::CoreExtensions::Date::Calculations
end
