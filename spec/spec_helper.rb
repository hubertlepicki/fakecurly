ENV["RACK_ENV"] = 'test'
require 'rspec'
require 'rack/test'
require File.join(File.dirname(__FILE__), "..", "lib", "fakecurly")

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:all) do
    @app = Rack::Test::Session.new(Rack::MockSession.new(Fakecurly))
  end

  config.before(:each) do
    Fakecurly.clear
  end
end

