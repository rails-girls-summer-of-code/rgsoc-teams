require 'spec_helper'

RSpec.describe Todo, :wip, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user)                  }
    it { is_expected.to belong_to(:application)           }
    it { should delegate_method(:season).to(:application) }
  end

  describe '.for_current_season' do
    let!(:todos) do
      FactoryGirl.create_list(:todo, 3,
        application: build(:application, :in_current_season)
      )
    end

    subject { described_class.for_current_season }

    before do
      FactoryGirl.create(:todo,
        application: build(:application, season: build(:season))
      )
      FactoryGirl.create(:todo,
        application: build(:application, :in_current_season, :skip_validations, team: nil)
      )
    end

    it 'returns only todos for applications with teams from the current season' do
      expect(subject).to match_array(todos)
    end
  end
end
