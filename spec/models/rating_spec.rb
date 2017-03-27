require 'spec_helper'

describe Rating do
  let(:application) { FactoryGirl.build(:application) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
    it { is_expected.to belong_to(:rateable) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :rateable }
    it { is_expected.to validate_presence_of :user_id }

    # shoulda matcher for uniqueness does not work in this scenario
    # https://github.com/thoughtbot/shoulda-matchers/issues/535
    # that's why we do it "by hand"
    it 'should only allow for one rating per user and rateable' do
      user = FactoryGirl.create :user
      Rating.create(rateable: application, user: user)
      expect{ Rating.create!(rateable: application, user: user) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'scopes' do
    describe 'by' do
      it 'should return the rating for the given user' do
        user = FactoryGirl.create(:user)
        rating = FactoryGirl.create(:rating, user: user, rateable: application)
        expect(Rating.by(user).first).to eq(rating)
      end
    end
  end

  describe '.user_names' do
    let!(:users) { FactoryGirl.create_list :reviewer, 3 }
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
      rating = FactoryGirl.create(:rating, rateable: application)
      rating.diversity = 1
      rating.save

      # after weights this should be:
      expect(rating.points).to be > 0
    end
  end

  describe '#to_s' do
    it 'returns the rounded points and the reviever name' do
      user   = FactoryGirl.build(:user)
      rating = FactoryGirl.build(:rating, user: user)
      expect(rating).to receive(:points)
        .and_return(6.66)
      expect(rating.to_s).to eq "#{user.name}: 6.7"
    end
  end
end
