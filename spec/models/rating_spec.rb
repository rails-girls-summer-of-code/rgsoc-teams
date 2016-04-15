require 'spec_helper'
describe Rating do
  let(:application) { FactoryGirl.build_stubbed(:application) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
    it { is_expected.to belong_to(:rateable) }

    let(:user) { FactoryGirl.build_stubbed(:user) }

    it 'should only allow for one rating per user and rateable' do
      Rating.create(rateable: application, user: user)
      expect{ Rating.create!(rateable: application, user: user) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'scopes' do
    describe 'by' do
      it 'should return the rating for the given user' do
        user = create(:user)
        rating = create(:rating, user: user, rateable: application)
        expect(Rating.by(user).first).to eq(rating)
      end
    end
  end
  describe '.user_names' do
    let(:users) { create_list :user, 3 }
    let(:user_names) { users.map(&:name) }

    before { users.each{|user| create(:rating, user: user, rateable: application) } }

    it 'returns names of all users who submitted a rating' do
      expect(Rating.user_names).to match_array user_names
    end

    it 'excludes other users' do
      user = create :user
      expect(Rating.user_names).not_to include user.name
    end
  end
  describe '#points' do
    it 'should add up some points given through valid fields' do
      rating = create(:rating, rateable: application)
      rating.diversity = 0
      rating.skills = 10
      rating.save

      # after weights this hsould be:
      expect(rating.points).to eq(1.5)
    end
  end
end
