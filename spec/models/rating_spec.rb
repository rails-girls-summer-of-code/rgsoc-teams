require 'spec_helper'

describe Rating do

  let(:rating) { FactoryGirl.create(:rating)}
  let(:user) { FactoryGirl.create(:user)}
  context 'data' do
    it 'should be defined' do
      expect(rating.data).not_to eql nil
    end
  end

  context 'user name' do
    it 'should be defined' do
      expect(Rating.user_names).to_not eql nil
    end
  end

  context 'done by a user' do
    it 'should be defined' do
      expect(Rating.by(user)).to_not eql nil
    end
  end
end
