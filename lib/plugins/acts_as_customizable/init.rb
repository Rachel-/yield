require File.dirname(__FILE__) + '/lib/acts_as_customizable'
ActiveRecord::Base.send(:include, Yield::Acts::Customizable)
