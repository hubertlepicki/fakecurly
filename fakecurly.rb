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

  get "/accounts/:code.xml" do
    @account = Fakecurly.accounts[params["code"]]
    if @account
      builder :accounts_show
    else
      not_found(builder :accounts_404)
    end
  end

  post "/accounts.xml" do
    puts params.inspect
    if params["account"] && params["account"]["account_code"].to_s != ""
      if Fakecurly.accounts[params["account"]["account_code"]]
        @errors = [["account_code", "Account code has already been taken"]]
        return builder(:errors)
      end
      @account = params["account"]
      Fakecurly.accounts[@account["account_code"]] = @account
      puts "created"
      builder :accounts_create
    else
      @errors = [["account_code", "Account code can't be blank"], ["account_code", "Account code is invalid"]]
      puts "errors.."
      builder :errors
    end
  end

  get "/accounts.xml" do

    puts Fakecurly.accounts.inspect
    @accounts = Fakecurly.accounts.values
    builder :accounts_index
  end

  put "/accounts/:code/billing_info.xml" do
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

  get "/accounts/:code/billing_info.xml" do
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

  post "/accounts/:code/subscription.xml" do
    @account = Fakecurly.accounts[params["code"]]
    @subscription = params["subscription"] || {}
    @errors = []

    if @account
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["address1"].nil?
        @errors << ["billing_info.address1", "Billing info.address1 can't be empty"]
      end
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["address1"].nil?
        @errors << ["billing_info.zip", "Billing info.zip can't be empty"]
      end
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["address1"].nil?
        @errors << ["billing_info.city", "Billing info.city can't be empty"]
      end
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["address1"].nil?
        @errors << ["billing_info.country", "Billing info.country can't be empty"]
      end

      if @subscription["account"]  && @errors.empty?
        if @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["credit_card"].nil? || @subscription["account"]["billing_info"]["credit_card"]["number"].to_s == "" || @subscription["account"]["billing_info"]["credit_card"]["number"].to_i != 1
          @errors << ["billing_info.number", "Billing info.number is not a valid number"]
        end

        @errors << ["billing_info.first_name", "Billing info.first_name can't be blank"] if @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["first_name"].nil?
        @errors << ["billing_info.last_name", "Billing info.last_name can't be blank"] if @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["last_name"].nil?
      end

      if @errors.empty? 
        builder :subscriptions_create
      else
        builder :errors
      end
    else
      not_found(builder :accounts_404)
    end
  end

  get "/accounts/:code/subscription.xml" do
    @account = Fakecurly.accounts[params["code"]]
    @subscription = Fakecurly.subscriptions[params["code"]]
    not_found(builder :subscriptions_404) if @account.nil? || @subscription.nil? 
  end

  get "/company/plans.xml" do
    @plans = Fakecurly.plans.values
    builder :plans_index
  end
end

