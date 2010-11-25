xml.instruct! :xml, version: "1.0", encoding: nil
xml.subscription do
  xml.id @account["account_code"]
  xml.account_code @account["account_code"]
  xml.plan do
    plan = Fakecurly.plans[@subscription["plan_code"]]
    xml.plan_code plan["plan_code"]
    xml.name plan["name"]
    xml.version 1, type: "integer"
  end
  xml.state "active"
  xml.quantity 1, type: "integer"
  xml.total_amount_in_cents 100, type: "integer"
  xml.activated_at "2010-01-01T00:00:00-00:00", type: "datetime"
  xml.canceled_at "", type: "datetime"
  xml.expires_at "", type: "datetime"
  xml.current_period_started_at "2010-01-01T00:00:00-00:00", type: "datetime"
  xml.current_period_ends_at "2100-01-01T00:00:00-00:00", type: "datetime"
  xml.trial_started_at "", type: "datetime"
  xml.trial_ends_at "", type: "datetime"
end

