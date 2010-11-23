require 'bundler'
# This actually requires the bundled gems
Bundler.require

class Fakecurly < Sinatra::Base
  class << self
    attr_accessor :accounts
    attr_accessor :plans
    attr_accessor :subscriptions

    def clear
      Fakecurly.plans = []
      Fakecurly.accounts = []
      Fakecurly.subscriptions = []
    end
  end

  def initialize
    Fakecurly.clear
    super
  end

  get "/accounts/:code" do
    @account = Fakecurly.accounts.select {|a| a["account_code"] == params["code"]}[0]
    builder :accounts_show
  end

  post "/accounts" do
    if params["account"] && params["account"]["account_code"].to_s != ""
      if Fakecurly.accounts.any? {|a| a["account_code"] == params["account"]["account_code"]}
        @errors = [["account_code", "Account code has already been taken"]]
        return builder(:errors)
      end

      Fakecurly.accounts << @account = params["account"]
      builder :accounts_create
    else
      @errors = [["account_code", "Account code can't be blank"], ["account_code", "Account code is invalid"]]
      builder :errors
    end
  end

  get "/accounts" do
    @accounts = Fakecurly.accounts
    builder :accounts_index
  end
end

