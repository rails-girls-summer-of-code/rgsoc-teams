FactoryGirl.define do
  factory :conference do
    name { [FFaker::CheesyLingo.title, 'Conf'].join ' ' }
    tickets 2
  end
end
