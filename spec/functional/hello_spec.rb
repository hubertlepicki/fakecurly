require 'spec_helper'

describe Fakecurly do
  it "should say hello" do
    @app.get "/"
    @app.last_response.body.should =~ /Hello/
  end
end
