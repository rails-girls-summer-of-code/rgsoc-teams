require 'spec_helper'

require 'cancan/matchers'

describe Rating do

  it { expect(subject).to belong_to(:application) }
  it { expect(subject).to belong_to(:user) }


  describe 'by' do

      let(:user) { create(:user) }
      it 'should return a user' do
       expect { Rating.by('user').should == :user }

    end
    end

   describe 'join' do
     let(:user) { create(:user)}

   it 'to be possible when not in any names' do

    expect { Rating.excluding(user).should!= :user }
     end
    end








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