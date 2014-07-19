require 'spec_helper'

describe Rating do

  let(:rating) { FactoryGirl.create(:rating)}
  let(:user) { FactoryGirl.create(:user)}
  context 'data' do
    it 'should be defined' do
      expect(rating.data).not_to eql nil
    end
  end

end
