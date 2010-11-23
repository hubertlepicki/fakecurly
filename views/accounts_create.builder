xml.instruct! :xml, version: "1.0", encoding: nil
xml.account do
  xml.account_code @account["account_code"]
  xml.username @account["username"]
  xml.email @account["email"]
  xml.first_name  @account["first_name"]
  xml.last_name @account["last_name"]
  xml.company_name @account["company_name"]
end
