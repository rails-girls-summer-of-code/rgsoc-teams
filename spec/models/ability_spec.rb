require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'ability takes new user as parameter' do
    subject {ability}

    let(:ability) { Ability.new(user) }

    context 'when a user is connected' do
      let(:user) { FactoryGirl.create(:user) }
      describe 'she/he is allowed to do everything on her/his account' do
        it { ability.should be_able_to(:show, user) }
        it { ability.should_not be_able_to(:create, User.new) } #this only happens through GitHub
      end
      
      context 'when a user is admin' do
        let(:user) { FactoryGirl.create(:user) }
        let(:organizer_role) { FactoryGirl.create(:organizer_role, user: user) }
        it "should be able to do anything on anyone's account" do
          expect(subject).to be_able_to(:crud, organizer_role)
        end
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
            ability.should be_able_to(:crud, attendance)
          end


          context 'when user is admin' do
            let!(:user) { FactoryGirl.create(:user) }
            let!(:organiser_role) { FactoryGirl.create(:organizer_role, user: user)}
            it "should be able to crud attendance" do
              expect(subject).to be_able_to :crud, attendance
            end
          end
        end

        context 'when different users' do
          let!(:other_user) { FactoryGirl.create(:user)}
          let!(:attendance) { FactoryGirl.create(:attendance, user: user)}
          it { ability.should_not be_able_to(:crud, other_user.attendances) }

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

  context 'to join helpdesk team' do
    let(:user) { FactoryGirl.create(:helpdesk) }
    let(:help) { FactoryGirl.create(:team, :helpdesk) }
    let(:team) { FactoryGirl.create(:team)}

    subject { ability }
    let(:ability) { Ability.new(user) }

    it 'should be logged in' do
      expect(ability.signed_in?(user)).to eql true
    end

    it 'should not be part of existing team' do
      expect(ability.on_team?(user, team)).to eql false
    end

    it 'should be able to join helpdesk team' do
      ability.should be_able_to(:join, help)
    end
  end
  end

  

  #context 'to supervise team' do
   # let(:user) { FactoryGirl.create(:user) }
   # let(:team) { FactoryGirl.create(:team) }

   # subject { ability }
  #  let(:ability) { Ability.new(user) }

    #let!(:organiser_role) { FactoryGirl.create(:organiser_role, user: user ) }
   # let!(:supervisor) { FactoryGirl.create(supervisor, user: user) }


    #it 'should be an supervisor' do

    #expect(subject).to be_able_to(:supervise, team)
 # end
#end
#end



