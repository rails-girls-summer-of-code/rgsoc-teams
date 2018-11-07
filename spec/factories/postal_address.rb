FactoryBot.define do
  factory :postal_address do
    user
    address_line_1 { FFaker::AddressUS.street_address }
    address_line_2 { FFaker::AddressUS.secondary_address }
    city { FFaker::AddressUS.city}
    state_or_province { FFaker::AddressUS.state}
    postal_code { FFaker::AddressUS.zip_code}
    country "Barbados"
  end
end
