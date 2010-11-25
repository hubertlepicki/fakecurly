xml.instruct! :xml, version: "1.0"
xml.account do
  xml.id @account["account_code"]
  xml.account_code @account["account_code"]
  xml.username @account["username"]
  xml.email @account["email"]
  xml.first_name  @account["first_name"]
  xml.last_name @account["last_name"]
  xml.company_name @account["company_name"]
  xml.balance_in_cents '0', type: 'integer'
  xml.closed false, type: "boolean"
  xml.hosted_login_token "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  xml.created_at "2010-01-01T00:00:00-00:00", type: "datetime"
  xml.state "active"
end
