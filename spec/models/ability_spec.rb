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

    describe 'a user should not be able to mark another\'s attendance to a conference' do

      context 'when same user' do
        let!(:user) { FactoryGirl.create(:user) }
        let!(:attendance) { FactoryGirl.create(:attendance, user: user)}

        it 'allows marking of attendance' do
          ability.should be_able_to(:update, attendance)
        end
      end

      context 'when different users' do
        let!(:other_user) { FactoryGirl.create(:user)}
        let!(:attendance) { FactoryGirl.create(:attendance, user: user)}
        it { ability.should_not be_able_to(:update, other_user.attendances) }
      end

    end

    context 'permitting activities' do
      context 'for feed_entries' do
        it 'allows anyone to read' do
          expect(Ability.new(nil)).to be_able_to :read, :feed_entry
        end
      end

      context 'for mailings' do
        it 'does not allow anonymous user to read' do
          expect(Ability.new(nil)).not_to be_able_to :read, :mailing
        end
        it 'allows signed in user to read' do
          expect(subject).to be_able_to :read, :mailing
        end
      end
    end
  end

end




