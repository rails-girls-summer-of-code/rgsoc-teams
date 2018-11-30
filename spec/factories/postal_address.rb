FactoryBot.define do
  factory :postal_address do
    user
    line1 { FFaker::AddressUS.street_address }
    line2 { FFaker::AddressUS.secondary_address }
    city { FFaker::AddressUS.city}
    state { FFaker::AddressUS.state}
    zip { FFaker::AddressUS.zip_code}
    country { "United States" }
  end
end
