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


#describe 'a user should not be able to mark another attendance to a conference' do
  #let(:user) { FactoryGirl.create(:user) }

  #let(:other_user) { FactoryGirl.create(:user) }
  #it { ability.should_not be_able_to(:update, other_user.attendances) }

  #end

describe 'a user should not be able to mark another attendance' do
  context 'when same user'
    let!(:user) { FactoryGirl.create(:user) }
    let!(:attendance) { FactoryGirl.create(:attendance, user: user)}
    
      #puts "user attendance: #{user.attendance.count}"
    it 'allow' do
      ability.should be_able_to(:update, attendance) 
    end

  context 'when different users' do
    let(:other_user) { FactoryGirl.create(:user) }

    it { ability.should_not be_able_to(:update, other_user.attendances)}
  end


end
end

end

