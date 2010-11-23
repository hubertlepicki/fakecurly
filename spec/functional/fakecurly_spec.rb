require 'spec_helper'

describe Fakecurly do
  def account_attributes(custom_attributes = {})
    { account_code: "ac",
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      company_name: "AmberBit" }.merge(custom_attributes)
  end

  context "clearing" do
    before :each do
      Fakecurly.accounts = ["Something"]
      Fakecurly.plans = ["Else"]
      Fakecurly.subscriptions = ["Foo"]
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
  end

  context "billing info" do
    it "should be possible to create a billing info for account"

    it "should be possible to update billing info for account"

    it "should check required fields when billing info provided"

    it "should check if credit card number is 1 when billing info provided"

    it "should be possible to get billing info for account"
  end

  context "subscription plans" do
    it "should list all subscription plans that we defined"

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
