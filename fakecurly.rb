require 'sinatra'
require 'i18n'
require 'rack/post-body-to-params'

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

  set :views, File.join(File.dirname(__FILE__), "lib", 'views')

  before do
    headers["Content-Type"] = "application/xml"
  end

  get "/clear" do
    Fakecurly.clear
    "<ahoy>All clear, sailor!</ahoy>"
  end

  post "/company/plans.xml" do
    Fakecurly.plans[params["plan"]["plan_code"]] = params["plan"]
    "<todo>OK, write me</todo>"
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
    if params["account"] && params["account"]["account_code"].to_s != ""
      if Fakecurly.accounts[params["account"]["account_code"]]
        @errors = [["account_code", "Account code has already been taken"]]
        status 422
        return builder(:errors)
      end
      @account = params["account"]
      Fakecurly.accounts[@account["account_code"]] = @account
      builder :accounts_create
    else
      @errors = [["account_code", "Account code can't be blank"], ["account_code", "Account code is invalid"]]
      status 422
      builder :errors
    end
  end

  get "/accounts.xml" do
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
        status 422
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
  
  delete "/accounts/:code/subscription.xml" do
    @account = Fakecurly.accounts[params["code"]]
    @subscription = Fakecurly.subscriptions[params["code"]]
    return not_found(builder :subscriptions_404) if @account.nil? || @subscription.nil? 

    Fakecurly.subscriptions[params["code"]] = nil
    builder :subscriptions_show
  end

  # TODO: Refactor this monster
  post "/accounts/:code/subscription.xml" do
    @account = Fakecurly.accounts[params["code"]]
    @subscription = params["subscription"] || {}
    @errors = []

    if @account
      if @subscription["account"] && @subscription["account"]["billing_info"].nil?
        @subscription["account"]["billing_info"] = Fakecurly.billing_infos[params["code"]]
      end
      @subscription["account"]
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["address1"].nil?
        @errors << ["billing_info.address1", "Billing info.address1 can't be empty"]
      end
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["zip"].nil?
        @errors << ["billing_info.zip", "Billing info.zip can't be empty"]
      end
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["city"].nil?
        @errors << ["billing_info.city", "Billing info.city can't be empty"]
      end
      if @subscription["account"].nil? || @subscription["account"]["billing_info"].nil? || @subscription["account"]["billing_info"]["country"].nil?
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
        Fakecurly.subscriptions[params["code"]] = @subscription
        builder :subscriptions_create
      else
        status 422
        builder :errors
      end
    else
      not_found(builder :accounts_404)
    end
  end

  get "/accounts/:code/subscription.xml" do
    @account = Fakecurly.accounts[params["code"]]
    @subscription = Fakecurly.subscriptions[params["code"]]
    return not_found(builder :subscriptions_404) if @account.nil? || @subscription.nil? 
    builder :subscriptions_show
  end

  put "/accounts/:code/subscription.xml" do
    @account = Fakecurly.accounts[params["code"]]
    @subscription = Fakecurly.subscriptions[params["code"]]
    return not_found(builder :subscriptions_404) if @account.nil? || @subscription.nil? 
    if params["subscription"] && params["subscription"]["plan_code"] && params["subscription"]["timeframe"] == "now"
      @subscription["plan_code"] = params["subscription"]["plan_code"]
    end 
    builder :subscriptions_show
  end

  get "/company/plans.xml" do
    @plans = Fakecurly.plans.values
    builder :plans_index
  end
end

