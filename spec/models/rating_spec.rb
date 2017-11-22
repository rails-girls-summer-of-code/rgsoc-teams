require 'spec_helper'

describe Rating, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:application).with_message(:required) }
    it { is_expected.to validate_presence_of(:user).with_message(:required)}
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:application_id) }
  end

  describe '.by' do
    subject(:ratings) { Rating.by(user) }

    let(:application) { build(:application) }
    let(:user)        { create(:user) }

    it 'returns only ratings by the given user' do
      rating       = create(:rating, user: user, application: application)
      other_rating = create(:rating, application: application)
      expect(ratings).to contain_exactly rating
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
