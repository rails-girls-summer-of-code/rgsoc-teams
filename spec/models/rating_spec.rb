require 'spec_helper'

describe Rating, type: :model, wip: true do
  let(:application) { build(:application) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application).inverse_of(:ratings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:application) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:application_id) }
  end

  describe 'scopes' do
    describe '.by' do
      it 'should return the rating for the given user' do
        user         = create(:user)
        rating       = create(:rating, user: user, application: application)
        other_rating = create(:rating, application: application)
        expect(Rating.by(user)).to contain_exactly rating
      end
    end
  end

  describe '.user_names' do
    let!(:users) { create_list :reviewer, 3 }
    let(:user_names) { users.map(&:name) }

    it 'returns names of all reviewers' do
      expect(Rating.user_names).to match_array user_names
    end

    it 'excludes other users' do
      user = create :user
      expect(Rating.user_names).not_to include user.name
    end
  end

  describe '#points' do
    it 'should add up some points given through valid fields' do
      rating = create(:rating)
      rating.diversity = 1
      rating.save

      # after weights this should be:
      expect(rating.points).to be > 0
    end
  end
end
