require 'spec_helper'
require 'cancan/matchers'

describe Rating do

  it { expect(subject).to belong_to(:application) }
  it { expect(subject).to belong_to(:user) }


  describe 'by' do

      let(:user) { create(:user) }
      it 'should return a user' do
       expect { Rating.by(user).should == :user }

    end
    end

   describe 'join' do
     let(:user) { create(:user)}

   it 'to be possible when not in any names' do

    expect { Rating.excluding(user).should!= :user }
     end
    end


  end

