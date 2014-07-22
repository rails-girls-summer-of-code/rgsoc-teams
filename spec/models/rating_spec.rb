require 'spec_helper'
describe Rating do

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:application) }
  end

  describe 'scopes' do
    describe 'by' do
      it 'should return the rating for the given user' do
        user = FactoryGirl.create(:user)
        rating = FactoryGirl.create(:rating, user: user)
        expect(Rating.by(user).first).to eq(rating)
      end
    end

  end
end
