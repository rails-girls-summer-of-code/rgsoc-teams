require 'spec_helper'

RSpec.describe Todo, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:season).to(:application) }
    it { is_expected.to delegate_method(:application_data).to(:application) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
    it { is_expected.to validate_presence_of(:application).with_message(:required) }

    it 'is invalid if there are already 4 todos assigned for the application' do
      application = create(:application)
      create_list(:todo, 4, application: application)
      todo = build(:todo, application: application)

      expect(todo).not_to be_valid
      expect(todo.errors.messages).to eq({ user: ['too many reviewers'] })
    end
  end

  describe '.for_current_season' do
    let(:application_from_other_season) { build(:application, season: build(:season)) }
    let(:application_without_team) { build(:application, :in_current_season, :skip_validations, team: nil) }
    let(:application_from_current_season) { build(:application, :in_current_season) }
    let!(:todos) { create_list(:todo, 3, application: application_from_current_season) }

    subject(:ratings) { described_class.for_current_season }

    before do
      create(:todo, application: application_from_other_season)
      create(:todo, application: application_without_team)
    end

    it 'returns todos for applications with teams from the current season' do
      expect(ratings).to match_array todos
    end
  end

  describe '#rating' do
    let(:todo) { create(:todo) }

    subject { todo.rating }

    it 'returns the rating if the user already rated the application' do
      rating = create(:rating, user: todo.user, application: todo.application)
      expect(subject).to eq rating
    end

    it 'returns nil if user did not yet rate the application' do
      expect(subject).to be_nil
    end
  end

  describe '#eligible?' do
    subject(:todo) { build(:todo) }

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
    subject(:todo) { create(:todo) }

    it 'returns true if the application has been rated' do
      rating = create(:rating, user: todo.user, application: todo.application)
      expect(todo).to be_done
    end

    it 'returns false if the application is not rated yet' do
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
