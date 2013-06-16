FactoryGirl.define do
  factory :role do
    team
    member
    name { Role::ROLES.sample }
  end
end
