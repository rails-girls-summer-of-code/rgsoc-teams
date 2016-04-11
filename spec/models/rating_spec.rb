require 'spec_helper'
describe Rating do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:application) }
  end

  describe 'scopes' do
    context 'user name' do
      it 'should be defined' do
        user = FactoryGirl.create(:user)
        rating = FactoryGirl.create(:rating, user: user)
        expect(Rating.user_names.first).to eql user.name
      end
    end

    context 'by' do
      it 'should return the rating for the given user' do
        user = FactoryGirl.create(:user)
        rating = FactoryGirl.create(:rating, user: user)
        expect(Rating.by(user).first).to eq(rating)
      end
    end

    context 'points' do
      it 'should add up some points given through valid fields' do
        rating = FactoryGirl.create(:rating)
        rating.data = { practice_time: 0, support: 2 }
        rating.save

        # practice time with id 0 is 10, support with id 2 is 6:
        expect(rating.points).to eq(16)
      end
    end
  end
end
