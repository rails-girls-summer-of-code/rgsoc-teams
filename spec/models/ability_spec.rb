require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let(:ability) { Ability.new(user) }

  context 'when a user is connected' do
    let(:user) { FactoryGirl.create(:user) }
    describe 'she/he is allowed to do everything on her/his account' do
      it { ability.should be_able_to(:show, user) }
      it { ability.should_not be_able_to(:create, User.new) } #this only happens through GitHub
    end

    describe 'she/he is not allowed to do everything on someone else account' do
      let(:other_user) { FactoryGirl.create(:user) }
      it { ability.should_not be_able_to(:show, other_user) }
    end
  end

  let(:ability) { Ability.new(user.admin) } 
    context 'when admin is connected'
    let(:user) { FactoryGirl.create(:user.admin)}
    describe 'she/he is allowed to update attendance if admin' do
      it { ability.should be_able_to(:update,attendances)}
    end
    
end
