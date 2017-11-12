require 'spec_helper'

RSpec.describe Todo, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
    it { is_expected.to delegate_method(:season).to(:application) }
    it { is_expected.to delegate_method(:application_data).to(:application) }
  end

  describe '.for_current_season' do
    let!(:todos) do
      create_list(:todo, 3,
        application: build(:application, :in_current_season)
      )
    end

    subject { described_class.for_current_season }

    before do
      create(:todo,
        application: build(:application, season: build(:season))
      )
      create(:todo,
        application: build(:application, :in_current_season, :skip_validations, team: nil)
      )
    end

    it 'returns only todos for applications with teams from the current season' do
      expect(subject).to match_array(todos)
    end
  end

  describe '#rating' do
    let!(:todo) { create(:todo) }

    subject { todo.rating }

    it 'returns rating if user rated application' do
      rating = build(:rating, user: todo.user, application: todo.application)
      rating.save(validate: false) # TODO: remove this once rating is updated
      expect(subject).to eq rating
    end

    it 'returns nil if user did not rate application' do
      expect(subject).to be_nil
    end
  end

  describe '#eligible?' do
    let(:todo) { build(:todo) }

    it 'returns true if application does not have any flags set' do
      todo.application.flags = []
      expect(todo).to be_eligible
    end

    it 'returns true if application does not have any blacklisted flags set' do
      todo.application.flags = ['random', 'more']
      expect(todo).to be_eligible
    end

    it 'returns false if application has any blacklisted flags set' do
      todo.application.flags = ['remote_team', 'random']
      expect(todo).not_to be_eligible
    end
  end

  describe '#done?' do
    let!(:todo) { create(:todo) }

    it 'returns true if application has been rated' do
      rating = build(:rating, user: todo.user, application: todo.application)
      rating.save(validate: false) # TODO: tmp solution
      expect(todo).to be_done
    end

    it 'returns false if application not rated yet' do
      expect(todo).not_to be_done
    end
  end

  describe '#sign_offs?' do
    let(:todo) { build(:todo) }

    it 'returns an array of booleans for the application sign_offs' do
      todo.application.application_data = { "signed_off_at_project1": Time.now.utc.to_s }
      expect(todo.sign_offs?).to eq [true, false]
    end
  end
end
