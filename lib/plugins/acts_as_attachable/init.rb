require File.dirname(__FILE__) + '/lib/acts_as_attachable'
ActiveRecord::Base.send(:include, Yield::Acts::Attachable)
