require 'bundler'
# This actually requires the bundled gems
Bundler.require

class Fakecurly < Sinatra::Base
  class << self
    attr_accessor :accounts
    attr_accessor :billing_infos
    attr_accessor :plans
    attr_accessor :subscriptions

    def clear
      Fakecurly.plans = {}
      Fakecurly.accounts = {}
      Fakecurly.billing_infos = {}
      Fakecurly.subscriptions = {}
    end
  end

  def initialize
    Fakecurly.clear
    super
  end

  get "/accounts/:code" do
    @account = Fakecurly.accounts[params["code"]]
    if @account
      builder :accounts_show
    else
      not_found(builder :accounts_404)
    end
  end

  post "/accounts" do
    if params["account"] && params["account"]["account_code"].to_s != ""
      if Fakecurly.accounts[params["account"]["account_code"]]
        @errors = [["account_code", "Account code has already been taken"]]
        return builder(:errors)
      end
      @account = params["account"]
      Fakecurly.accounts[@account["account_code"]] = @account
      builder :accounts_create
    else
      @errors = [["account_code", "Account code can't be blank"], ["account_code", "Account code is invalid"]]
      builder :errors
    end
  end

  get "/accounts" do
    @accounts = Fakecurly.accounts.values
    builder :accounts_index
  end

  put "/accounts/:code/billing_info" do
    @account = Fakecurly.accounts[params["code"]]
    if @account
      @billing_info = Fakecurly.billing_infos[@account["account_code"]] = params[:billing_info]
      @errors = []
      if @billing_info["credit_card"].nil? || @billing_info["credit_card"]["number"].to_s == "" || @billing_info["credit_card"]["number"].to_i != 1
        @errors << ["number", "Number is not a valid number"]
      end
      @errors << ["first_name", "First name can't be blank"] if @billing_info["first_name"].nil?
      @errors << ["last_name", "Last name can't be blank"] if @billing_info["first_name"].nil?
      if !@errors.empty?
        builder :errors
      else
        builder :billing_infos_show
      end
    else
      not_found(builder :accounts_404)
    end
  end

  get "/accounts/:code/billing_info" do
    @account = Fakecurly.accounts[params["code"]]
    if @account
      @billing_info = Fakecurly.billing_infos[@account["account_code"]]
      @billing_info ||= {
        "first_name" => @account["first_name"],
        "last_name" => @account["last_name"],
        "credit_card" => {
           "month" => Time.now.month,
           "year" => Time.now.year 
         }
      }

      builder :billing_infos_show
    else
      not_found(builder :accounts_404)
    end
  end


end

