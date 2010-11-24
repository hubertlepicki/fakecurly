xml.instruct! :xml, version: '1.0', encoding: nil
xml.subscription do
  xml.plan_code @subscription["plan_code"]
  xml.quantity 1
  xml.account do
    xml.account_code @subscription["account"]["account_code"]
    xml.username @subscription["account"]["username"]
    xml.email @subscription["account"]["email"]
    xml.first_name  @subscription["account"]["first_name"]
    xml.last_name @subscription["account"]["last_name"]
    xml.company_name @subscription["account"]["company_name"]
    xml.billing_info do
      xml.first_name @subscription["account"]["billing_info"]["first_name"]
      xml.last_name @subscription["account"]["billing_info"]["last_name"]
      xml.address1 @subscription["account"]["billing_info"]["address1"]
      xml.address2 @subscription["account"]["billing_info"]["address2"]
      xml.city @subscription["account"]["billing_info"]["city"]
      xml.state @subscription["account"]["billing_info"]["state"]
      xml.zip @subscription["account"]["billing_info"]["zip"]
      xml.country @subscription["account"]["billing_info"]["country"]
      xml.ip_address @subscription["account"]["billing_info"]["ip_address"]
      xml.credit_card do
        xml.number @subscription["account"]["billing_info"]["credit_card"]["number"]
        xml.verification_value ""
        xml.year @subscription["account"]["billing_info"]["credit_card"]["year"]
        xml.month @subscription["account"]["billing_info"]["credit_card"]["month"]
      end
   end
  end
end
