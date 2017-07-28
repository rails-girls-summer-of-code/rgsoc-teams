FactoryGirl.define do
  factory :team do
    kind 'sponsored'
    sequence(:name) { |i| "#{i}-#{FFaker::CheesyLingo.word.capitalize}" }

    trait :helpdesk do
      name 'helpdesk'
    end

    trait :in_current_season do
      season { Season.current }
    end

    trait :last_season do
      season { Season.find_or_create_by name: (Date.today.year - 1) }
    end

    trait :supervise do
      name 'supervise'
    end

    trait :with_students do
      after(:create) do |team|
        %w(student student).each do |role|
          team.roles.create name: role, user: create(:user)
          team
        end
      end
    end

    trait :applying_team do
      name { FFaker::Product.brand }

      after(:create) do |team|
        %w(student student mentor coach).each do |role|
          team.roles.create name: role, user: create(:user)
          team
        end
      end
    end

    trait :with_applications do
      after(:create) do |team|
        # team.applications.create build(:application, team: nil).attributes
        create_list :application, 2, team: team
        team
      end
    end
  end
end
