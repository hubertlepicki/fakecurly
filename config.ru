ENV['RACK_ENV'] ||= "test"

require File.join(File.dirname(__FILE__), 'fakecurly')
use Rack::PostBodyToParams
run Fakecurly
