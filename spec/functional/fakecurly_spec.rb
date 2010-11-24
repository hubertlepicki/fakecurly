# encoding: UTF-8
require 'spec_helper'

describe Fakecurly do
  def account_attributes(custom_attributes = {})
    { account_code: "ac",
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      company_name: "AmberBit" }.merge(custom_attributes)
  end

  def billing_info_attributes(custom_attributes = {})
    { first_name: "John",
      last_name: "Doe",
      address1: "Some address",
      address2: "cnt",
      city: "Bialystok",
      state: "Podlaskie",
      country: "Polska",
      zio: "15-444",
      phone: "444444444",
      vat_number: "3333333333",
      ip_address: "127.0.0.1",
      credit_card: {
        number: 1,
        month: 11,
        year: 2011
      }
    }.merge(custom_attributes)
  end


  context "clearing" do
    before :each do
      Fakecurly.accounts = {"foo" => "bar"}
      Fakecurly.billing_infos = {"foo" => "bar"}
      Fakecurly.plans = {"foo" => "bar"}
      Fakecurly.subscriptions = {"foo" => "bar"}
      Fakecurly.clear
    end

    it "should clear accounts" do
      Fakecurly.accounts.should be_empty
    end

    it "should clear plans" do
      Fakecurly.plans.should be_empty
    end

    it "should clear accounts" do
      Fakecurly.plans.should be_empty
    end

    it "should clear billing infos" do
      Fakecurly.billing_infos.should be_empty
    end
 
  end

  context "creating accounts" do
    it "should be possible to create account with valid attributes" do
      @app.request "/accounts", method: :post, params: {account: account_attributes}
      Fakecurly.accounts.count.should eql(1)
    end

    it "should return account info when created account" do
      @app.request "/accounts", method: :post, params: {account: account_attributes}
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0"?>
<account>
  <account_code>#{account_attributes[:account_code]}</account_code>
  <username></username>
  <email>#{account_attributes[:email]}</email>
  <first_name>#{account_attributes[:first_name]}</first_name>
  <last_name>#{account_attributes[:last_name]}</last_name>
  <company_name>#{account_attributes[:company_name]}</company_name>
</account>
BEGIN
      ) 
    end

    it "should require valid attributes when creating account" do
       @app.request "/accounts", method: :post, params: {account: account_attributes(account_code: nil)}

       @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error field="account_code">Account code can't be blank</error>
  <error field="account_code">Account code is invalid</error>
</errors>
BEGIN
       )
    end

    it "should require valid attributes when creating account" do
       @app.request "/accounts", method: :post, params: {account: account_attributes(account_code: nil)}

       @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error field="account_code">Account code can't be blank</error>
  <error field="account_code">Account code is invalid</error>
</errors>
BEGIN
       )
    end
  end

  context "account information" do
    before :each do
      @app.request "/accounts", method: :post, params: {account: account_attributes(account_code: "foo")}
      @app.request "/accounts", method: :post, params: {account: account_attributes(account_code: "bar")}
    end

    it "should be possible to list accounts" do
      @app.get "/accounts"
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<accounts type="collection">
  <current_page type="integer">1</current_page>
  <per_page type="integer">20</per_page>
  <total_entries type="integer">2</total_entries>
  <account>
    <account_code>foo</account_code>
    <username></username>
    <email>#{account_attributes[:email]}</email>
    <first_name>#{account_attributes[:first_name]}</first_name>
    <last_name>#{account_attributes[:last_name]}</last_name>
    <company_name>#{account_attributes[:company_name]}</company_name>
    <balance_in_cents type="integer">0</balance_in_cents>
  </account>
  <account>
    <account_code>bar</account_code>
    <username></username>
    <email>#{account_attributes[:email]}</email>
    <first_name>#{account_attributes[:first_name]}</first_name>
    <last_name>#{account_attributes[:last_name]}</last_name>
    <company_name>#{account_attributes[:company_name]}</company_name>
    <balance_in_cents type="integer">0</balance_in_cents>
  </account>
</accounts>
BEGIN
)
    end
       
    it "should be possible to get individual account data" do
      @app.get "/accounts/foo"
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<account>
  <id>foo</id>
  <account_code>foo</account_code>
  <username></username>
  <email>#{account_attributes[:email]}</email>
  <first_name>#{account_attributes[:first_name]}</first_name>
  <last_name>#{account_attributes[:last_name]}</last_name>
  <company_name>#{account_attributes[:company_name]}</company_name>
  <balance_in_cents type="integer">0</balance_in_cents>
  <closed type="boolean">false</closed>
  <hosted_login_token>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</hosted_login_token>
  <created_at type="datetime">2010-01-01T00:00:00-00:00</created_at>
  <state>active</state>
</account>
BEGIN
      )
    end

    it "should return 404 when not found an account" do
      @app.get "/accounts/nonexistent"
      @app.last_response.status.should eql(404)
    end

    it "should return error message when not found an account" do
      @app.get "/accounts/nonexistent"
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error>Account not found</error>
</errors>
BEGIN
    )
  end
end

context "billing info" do
  before :each do
    @app.request "/accounts", method: :post, params: {account: account_attributes}
  end

  it "should be possible to create a billing info for account" do
    @app.request "/accounts/#{account_attributes[:account_code]}/billing_info", method: :put, params: {billing_info: billing_info_attributes}      
    @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<billing_info>
  <account_code>#{account_attributes[:account_code]}</account_code>
  <first_name>#{billing_info_attributes[:first_name]}</first_name>
  <last_name>#{billing_info_attributes[:last_name]}</last_name>
  <address1>#{billing_info_attributes[:address1]}</address1>
  <address2>#{billing_info_attributes[:address2]}</address2>
  <city>#{billing_info_attributes[:city]}</city>
  <state>#{billing_info_attributes[:state]}</state>
  <country>#{billing_info_attributes[:country]}</country>
  <zip>#{billing_info_attributes[:zip]}</zip>
  <phone>#{billing_info_attributes[:phone]}</phone>
  <vat_number>#{billing_info_attributes[:vat_number]}</vat_number>
  <ip_address>#{billing_info_attributes[:ip_address]}</ip_address>
  <credit_card>
    <type>bogus</type>
    <last_four>#{billing_info_attributes[:credit_card][:ip_address]}</last_four>
    <month type="integer">#{billing_info_attributes[:credit_card][:month]}</month>
    <year type="integer">#{billing_info_attributes[:credit_card][:year]}</year>
  </credit_card>
  <updated_at type="datetime">2010-01-01T00:00:00-00:00</updated_at>
</billing_info>
BEGIN
      )
    end

    it "should return 404 when trying to update billing inf for non-existent account" do
      @app.request "/accounts/nonexistent/billing_info", method: :put, params: {billing_info: billing_info_attributes}
      @app.last_response.status.should eql(404)
    end

    it "should return 404 when trying to update billing inf for non-existent account" do
      @app.request "/accounts/nonexistent/billing_info", method: :put, params: {billing_info: billing_info_attributes}
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error>Account not found</error>
</errors>
BEGIN
      )
    end

    it "should check required fields when billing info provided" do
      @app.request "/accounts/#{account_attributes[:account_code]}/billing_info", method: :put, params: {billing_info: billing_info_attributes(first_name: nil, last_name: nil, credit_card: {number: nil})}      
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error field="number">Number is not a valid number</error>
  <error field="first_name">First name can't be blank</error>
  <error field="last_name">Last name can't be blank</error>
</errors>
BEGIN
      )
    end

    it "should check if credit card number is 1 when billing info provided" do
      @app.request "/accounts/#{account_attributes[:account_code]}/billing_info", method: :put, params: {billing_info: billing_info_attributes(credit_card: {number: 2})}      
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<errors>
  <error field="number">Number is not a valid number</error>
</errors>
BEGIN
      )
    end

    it "should be possible to get billing info for account" do
      @app.request "/accounts/#{account_attributes[:account_code]}/billing_info", method: :put, params: {billing_info: billing_info_attributes}      
      @app.get "/accounts/#{account_attributes[:account_code]}/billing_info"
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<billing_info>
  <account_code>#{account_attributes[:account_code]}</account_code>
  <first_name>#{billing_info_attributes[:first_name]}</first_name>
  <last_name>#{billing_info_attributes[:last_name]}</last_name>
  <address1>#{billing_info_attributes[:address1]}</address1>
  <address2>#{billing_info_attributes[:address2]}</address2>
  <city>#{billing_info_attributes[:city]}</city>
  <state>#{billing_info_attributes[:state]}</state>
  <country>#{billing_info_attributes[:country]}</country>
  <zip>#{billing_info_attributes[:zip]}</zip>
  <phone>#{billing_info_attributes[:phone]}</phone>
  <vat_number>#{billing_info_attributes[:vat_number]}</vat_number>
  <ip_address>#{billing_info_attributes[:ip_address]}</ip_address>
  <credit_card>
    <type>bogus</type>
    <last_four>#{billing_info_attributes[:credit_card][:ip_address]}</last_four>
    <month type="integer">#{billing_info_attributes[:credit_card][:month]}</month>
    <year type="integer">#{billing_info_attributes[:credit_card][:year]}</year>
  </credit_card>
  <updated_at type="datetime">2010-01-01T00:00:00-00:00</updated_at>
</billing_info>
BEGIN
      )
    end

    it "should be possible to get default billing info for account" do
      @app.get "/accounts/#{account_attributes[:account_code]}/billing_info"
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<billing_info>
  <account_code>#{account_attributes[:account_code]}</account_code>
  <first_name>#{account_attributes[:first_name]}</first_name>
  <last_name>#{account_attributes[:last_name]}</last_name>
  <address1></address1>
  <address2></address2>
  <city></city>
  <state></state>
  <country></country>
  <zip></zip>
  <phone></phone>
  <vat_number></vat_number>
  <ip_address></ip_address>
  <credit_card>
    <type>unknown</type>
    <last_four></last_four>
    <month type="integer">#{Time.now.month}</month>
    <year type="integer">#{Time.now.year}</year>
  </credit_card>
  <updated_at type="datetime">2010-01-01T00:00:00-00:00</updated_at>
</billing_info>
BEGIN
      )
    end
  end

  context "subscription plans" do
    before :each do
      Fakecurly.plans = {
        "plan1" => {
          "plan_code" => "plan1",
          "name" => "Plan 1",
          "description" => "First plan",
          "unit_amount_in_cents" => 100,
          "setup_fee_in_cents" => 0,
          "plan_interval_length" => 1,
          "plan_interval_unit" => "months",
          "trial_interval_length" => 1,
          "trial_interval_unit" => "months"
        },
        "plan2" => {
          "plan_code" => "plan2",
          "name" => "Plan 2",
          "description" => "Second plan",
          "unit_amount_in_cents" => 200,
          "setup_fee_in_cents" => 0,
          "plan_interval_length" => 1,
          "plan_interval_unit" => "months",
          "trial_interval_length" => 0,
          "trial_interval_unit" => "months"
        }
      }
    end

    it "should list all subscription plans that we defined" do
      @app.get "/company/plans"
      @app.last_response.body.should eql(
<<BEGIN
<?xml version="1.0" encoding="UTF-8"?>
<plans type="array">
  <plan>
    <plan_code>plan1</plan_code>
    <name>Plan 1</name>
    <description>First plan</description>
    <created_at type="datetime">2010-01-01T00:00:00-00:00</created_at>
    <unit_amount_in_cents type="integer">100</unit_amount_in_cents>
    <setup_fee_in_cents type="integer">0</setup_fee_in_cents>
    <plan_interval_length type="integer">1</plan_interval_length>
    <plan_interval_unit>months</plan_interval_unit>
    <trial_interval_length type="integer">1</trial_interval_length>
    <trial_interval_unit>months</trial_interval_unit>
    <latest_version depreciated="true">
      <version type="integer">1</version>
      <unit_amount_in_cents type="integer">100</unit_amount_in_cents>
      <setup_fee_in_cents type="integer">0</setup_fee_in_cents>
      <plan_interval_length type="integer">1</plan_interval_length>
      <plan_interval_unit>months</plan_interval_unit>
      <trial_interval_length type="integer">1</trial_interval_length>
      <trial_interval_unit>months</trial_interval_unit>
      <created_at type="datetime">2010-01-01T00:00:00-00:00</created_at>
    </latest_version>
  </plan>
  <plan>
    <plan_code>plan2</plan_code>
    <name>Plan 2</name>
    <description>Second plan</description>
    <created_at type="datetime">2010-01-01T00:00:00-00:00</created_at>
    <unit_amount_in_cents type="integer">200</unit_amount_in_cents>
    <setup_fee_in_cents type="integer">0</setup_fee_in_cents>
    <plan_interval_length type="integer">1</plan_interval_length>
    <plan_interval_unit>months</plan_interval_unit>
    <trial_interval_length type="integer">0</trial_interval_length>
    <trial_interval_unit>months</trial_interval_unit>
    <latest_version depreciated="true">
      <version type="integer">1</version>
      <unit_amount_in_cents type="integer">200</unit_amount_in_cents>
      <setup_fee_in_cents type="integer">0</setup_fee_in_cents>
      <plan_interval_length type="integer">1</plan_interval_length>
      <plan_interval_unit>months</plan_interval_unit>
      <trial_interval_length type="integer">0</trial_interval_length>
      <trial_interval_unit>months</trial_interval_unit>
      <created_at type="datetime">2010-01-01T00:00:00-00:00</created_at>
    </latest_version>
  </plan>
</plans>
BEGIN
      )
    end

    it "should get subscription plans information"
  end

  context "subscriptions" do
    it "should be possible to create subscription for account"
    it "should get a subscription for account"
    it "should be possible to update subscription for account"
    it "should be possible to cancel subscription"
    it "should be possible to re-activate subscription"
  end
end
