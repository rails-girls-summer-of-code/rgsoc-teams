FactoryGirl.define do
  factory :team do
    kind 'sponsored'
    sequence(:name) { |i| "#{i}-#{FFaker::Lorem.word}" }
  end

  trait :helpdesk do
    name 'helpdesk'
  end

  trait :supervise do
    name 'supervise'
  end

  trait :applying_team do
    name 'full team'

    after(:create) do |team|
      %w(student student mentor coach).each do |role|
        team.roles.create name: role, user: create(:user)
      end
      team
    end
  end

end
