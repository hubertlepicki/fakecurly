xml.instruct! :xml, version: '1.0'
xml.plans type: :array do
  @plans.each do |plan|
    xml.plan do
      xml.plan_code plan["plan_code"]
      xml.name plan["name"]
      xml.description plan["description"]
      xml.created_at "2010-01-01T00:00:00-00:00", type: "datetime"
      xml.unit_amount_in_cents plan["unit_amount_in_cents"], type: "integer"
      xml.setup_fee_in_cents plan["setup_fee_in_cents"], type: "integer"
      xml.plan_interval_length plan["plan_interval_length"], type: "integer"
      xml.plan_interval_unit plan["plan_interval_unit"]
      xml.trial_interval_length plan["trial_interval_length"], type: "integer"
      xml.trial_interval_unit plan["trial_interval_unit"]
      xml.latest_version depreciated: true do
        xml.version 1, type: "integer"
          xml.unit_amount_in_cents plan["unit_amount_in_cents"], type: "integer"
          xml.setup_fee_in_cents plan["setup_fee_in_cents"], type: "integer"
          xml.plan_interval_length plan["plan_interval_length"], type: "integer"
          xml.plan_interval_unit plan["plan_interval_unit"]
          xml.trial_interval_length plan["trial_interval_length"], type: "integer"
          xml.trial_interval_unit plan["trial_interval_unit"]
          xml.created_at "2010-01-01T00:00:00-00:00", type: "datetime"
      end
    end
  end
end
 
