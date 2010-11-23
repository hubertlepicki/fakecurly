require 'bundler'
# This actually requires the bundled gems
Bundler.require

class Fakecurly < Sinatra::Base
  get "/" do
    "Hello, world of sinatra"
  end
end

