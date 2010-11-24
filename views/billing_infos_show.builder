xml.instruct! :xml, version: "1.0"
xml.billing_info do
  xml.account_code @account["account_code"]
  xml.first_name @billing_info["first_name"]
  xml.last_name @billing_info["last_name"]
  xml.address1 @billing_info["address1"]
  xml.address2 @billing_info["address2"]
  xml.city @billing_info["city"]
  xml.state @billing_info["state"]
  xml.country @billing_info["country"]
  xml.zip @billing_info["zip"]
  xml.phone @billing_info["phone"]
  xml.vat_number @billing_info["vat_number"]
  xml.ip_address @billing_info["ip_address"]
  xml.credit_card do
    xml.type @billing_info["credit_card"]["number"] == "1" ? "bogus" : "unknown"
    xml.last_four @billing_info["credit_card"]["number"].to_s[-4..-1]
    xml.month @billing_info["credit_card"]["month"], type: "integer"
    xml.year @billing_info["credit_card"]["year"], type: "integer"
  end
  xml.updated_at "2010-01-01T00:00:00-00:00", type: "datetime"
end
 
