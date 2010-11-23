ENV['RACK_ENV'] ||= "test"

require File.join(File.dirname(__FILE__), 'fakecurly')

run Fakecurly
