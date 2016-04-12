require 'spec_helper'
describe Rating do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
    it { is_expected.to belong_to(:rateable) }
  end

  describe 'scopes' do
    describe 'by' do
      it 'should return the rating for the given user' do
        user = create(:user)
        rating = create(:rating, user: user)
        expect(Rating.by(user).first).to eq(rating)
      end
    end
  end
  describe '.user_names' do
    let(:users) { create_list :user, 3 }
    let(:user_names) { users.map(&:name) }

    before { users.each{|user| create(:rating, user: user) } }

    it 'returns names of all users who submitted a rating' do
      expect(Rating.user_names).to match_array user_names
    end

    it 'contains each name only once' do
      create :rating, user: users.first
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
      rating.data = { practice_time: 0, support: 2 }
      rating.save

      # practice time with id 0 is 10, support with id 2 is 6:
      expect(rating.points).to eq(16)
    end
  end
end
