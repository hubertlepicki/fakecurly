xml.instruct! :xml, version: '1.0'
xml.errors do
  @errors.each do |error| 
    xml.error error[1], field: error[0]
  end
end
