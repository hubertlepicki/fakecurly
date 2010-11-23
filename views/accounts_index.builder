xml.instruct! :xml, version: '1.0'
xml.accounts type: :collection do
  xml.current_page '1', type: 'integer'
  xml.per_page '20', type: 'integer'
  xml.total_entries @accounts.count, type: 'integer'
  @accounts.each do |account|
    xml.account do
      xml.account_code account['account_code']
      xml.username account['username']
      xml.email account['email']
      xml.first_name  account['first_name']
      xml.last_name account['last_name']
      xml.company_name account['company_name']
      xml.balance_in_cents '0', type: 'integer'
    end
  end
end
