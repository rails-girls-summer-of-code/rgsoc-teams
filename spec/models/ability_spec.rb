require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let(:ability) { Ability.new(user) }

  context 'ability' do
    context 'when a user is connected' do
      let!(:user) { FactoryGirl.create(:user) }
      describe 'she/he is allowed to do everything on her/his account' do
        it { expect(ability).to be_able_to(:show, user) }
        it { expect(ability).not_to be_able_to(:create, User.new) } #this only happens through GitHub
      end

      context 'when a user is admin' do
        let(:organizer_role) { FactoryGirl.create(:organizer_role, user: user) }
        it "should be able to CRUD on anyone's account" do
          expect(subject).to be_able_to(:crud, organizer_role)
        end
      end

      describe 'she/he is not allowed to CRUD on someone else account' do
        let(:other_user) { FactoryGirl.create(:user) }
        it { expect(ability).not_to be_able_to(:show, other_user) }
      end

      describe 'a user should not be able to mark another\'s attendance to a conference' do

        context 'when same user' do
          let!(:attendance) { FactoryGirl.create(:attendance, user: user)}

          it 'allows marking of attendance' do
            expect(ability).to be_able_to(:crud, attendance)
          end


          context 'when user is admin' do
            let!(:organiser_role) { FactoryGirl.create(:organizer_role, user: user)}
            it "should be able to crud attendance" do
              expect(subject).to be_able_to :crud, attendance
            end
          end
        end

        context 'when different users' do
          let!(:other_user) { FactoryGirl.create(:user)}
          let!(:attendance) { FactoryGirl.create(:attendance, user: user)}
          it { expect(ability).not_to be_able_to(:crud, other_user.attendances) }

        end
      end

      describe 'to read user info' do
        context 'if not an admin or supervisor' do
          before do
            allow(user).to receive(:admin?).and_return(false)
            allow(user).to receive(:supervisor?).and_return(false)
          end

          it { expect(ability).not_to be_able_to(:read, :users_info) }
        end

        context 'if an admin' do
          before do
            allow(user).to receive(:admin?).and_return(true)
            allow(user).to receive(:supervisor?).and_return(false)
          end

          it { expect(ability).to be_able_to(:read, :users_info) }
        end

        context 'if a supervisor' do
          before do
            allow(user).to receive(:admin?).and_return(false)
            allow(user).to receive(:supervisor?).and_return(true)
          end

          it { expect(ability).to be_able_to(:read, :users_info) }
        end

      end

      describe 'access to mailings' do
        let!(:mailing) { Mailing.new }
        let!(:user) { FactoryGirl.create(:student) }

        context 'when user is admin' do
          let(:user) { FactoryGirl.create(:organizer) }

          it { expect(subject).to be_able_to :crud, mailing }
        end

        context 'when user is a recipient' do
          it 'allows to read' do
            mailing.to = %w(students)
            expect(subject).to be_able_to :read, mailing
          end
        end

        context 'when user has nothing to do with the mailing' do
          it 'will not allow to read' do
            expect(subject).not_to be_able_to :read, mailing
          end
        end
      end

      describe 'operations on teams' do
        let(:team) { create :team }

        context 'when user admin' do
          let(:user) { create :organizer }

          it 'allows crud' do
            expect(subject).to be_able_to :crud, team
          end
        end
        context 'when user student' do
          let!(:user) { create :student }

          it 'allows crud on new team' do
            expect(subject).to be_able_to :crud, Team.new
          end

          it 'allows crud on own team' do
            create :student_role, team: team, user: user
            expect(subject).to be_able_to :crud, team
          end

          it 'does not allow crud on other team' do
            expect(subject).not_to be_able_to :crud, team
          end

          context 'when in team for season' do
            before { create :student_role, team: student_team, user: user }
            let(:student_team) { create(:team, :in_current_season) }

            it 'allows crud on own team' do
              expect(subject).to be_able_to :crud, student_team
            end

            it 'allows to create team for different season' do
              expect(subject).to be_able_to :create, Team.new
            end

            it 'does not allow to create team for same season' do
              expect(subject).not_to be_able_to :create, Team.new(season: student_team.season)
            end
          end
        end
        context 'when user guest (not persisted)' do
          let(:user) { build :user }

          it 'does not allow crud on existing team' do
            expect(subject).not_to be_able_to :crud, team
          end
          
          it 'does not allow to create team' do
            expect(subject).not_to be_able_to :create, Team.new
          end
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
    let(:team) { FactoryGirl.create(:team) }

    it 'should be logged in' do
      expect(ability.signed_in?(user)).to eql true
    end

    it 'should not be part of existing team' do
      expect(ability.on_team?(user, team)).to eql false
    end

    it 'should be able to join helpdesk team' do
      helpdesk_team = FactoryGirl.create(:team, :helpdesk)
      expect(ability).to be_able_to(:join, helpdesk_team)
    end
  end
end
