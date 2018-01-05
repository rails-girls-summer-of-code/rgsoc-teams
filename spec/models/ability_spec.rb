require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject { ability }
  let(:ability) { Ability.new(user) }

  context 'ability' do
    context 'when a user is connected' do
      let!(:user) { create(:user) }
      let!(:team) { create(:team) }

      describe 'she/he is allowed to do everything on her/his account' do
        it { expect(ability).to be_able_to(:show, user) }
        it { expect(ability).not_to be_able_to(:create, User.new) } # this only happens through GitHub

        it { expect(ability).to be_able_to(:resend_confirmation_instruction, user) }
      end

      context 'when a user is admin' do
        let(:organizer_role) { create(:organizer_role, user: user) }
        it "should be able to CRUD on anyone's account" do
          expect(subject).to be_able_to(:crud, organizer_role)
        end
      end

      describe 'she/he is not allowed to CRUD on someone else account' do
        let(:other_user) { create(:user) }
        it { expect(ability).not_to be_able_to(:show, other_user) }
      end


      describe 'who is allowed to see email address in user profile' do

        # email address is hidden: admin, user's supervisor in current season (confirmed)
        # email address is not hidden: admin, confirmed user, user him/herself

        let(:other_user) { create(:user) }

        context 'when email address is hidden' do
          context 'when an admin' do
            before do
              allow(user).to receive(:admin?).and_return(true)
              allow(ability).to receive(:supervises?).with(other_user, user).and_return(false)
            end
            it 'allows to see hidden email address' do
              other_user.hide_email = true
              expect(ability).to be_able_to(:read_email, other_user)
            end
          end

          context "when user's supervisor in current season (confirmed)" do
            before do
              allow(user).to receive(:admin?).and_return(false)
              allow(ability).to receive(:supervises?).with(other_user, user).and_return(true)
              allow(user).to receive(:confirmed?).and_return(true)
            end
            it 'allows to see hidden email address' do
              other_user.hide_email = true
              expect(ability).to be_able_to(:read_email, other_user)
            end
          end
        end

        context 'when email address is not hidden' do
          context 'when an admin' do
            before do
              allow(user).to receive(:admin?).and_return(true)
              allow(user).to receive(:confirmed?).and_return(false)
            end
            it 'allows to see not hidden email address' do
              other_user.hide_email = false
              expect(ability).to be_able_to(:read_email, other_user)
            end
          end

          context 'when a confirmed user' do
            before do
              allow(user).to receive(:admin?).and_return(false)
              allow(user).to receive(:confirmed?).and_return(true)
            end
            it 'allows to see not hidden email address' do
              other_user.hide_email = false
              expect(ability).to be_able_to(:read_email, other_user)
            end
          end

          context 'when the user him/herself' do
            it 'allows to see not hidden email address' do
              user.hide_email = false
              expect(ability).to be_able_to(:read_email, user)
            end
          end
        end

      end

      describe 'who is disallowed to see email address in user profile' do

        # email address is hidden: not admin, not user's supervisor in current season
        # email address is not hidden: not admin, not confirmed user, not user him/herself

        let(:other_user) { create(:user) }

        context 'when email address is hidden' do
          context "when not an admin or user's supervisor in current season" do
            before do
              allow(user).to receive(:admin?).and_return(false)
              allow(ability).to receive(:supervises?).with(other_user, user).and_return(false)
            end
            it 'disallows to see hidden email address' do
              other_user.hide_email = true
              expect(ability).not_to be_able_to(:read_email, other_user)
            end
          end
        end

        context 'when email address is not hidden' do
          context 'when not an admin or confirmed user or user him/herself' do
            before do
              allow(user).to receive(:admin?).and_return(false)
              allow(user).to receive(:confirmed?).and_return(false)
            end
            it 'disallows to see not hidden email address' do
              other_user.hide_email = false
              expect(ability).not_to be_able_to(:read_email, other_user)
            end
          end
        end

      end


      context 'resend_confirmation_instruction' do
        let(:other_user) { create(:user) }

        describe 'a user can only resend her/his own confirmation' do
          it { expect(ability).to be_able_to(:resend_confirmation_instruction, user) }
          it { expect(ability).not_to be_able_to(:resend_confirmation_instruction, other_user) }
        end

        describe 'a admin can resend all confirmation tokens' do
          let!(:organizer_role) { create(:organizer_role, user: user) }
          it { expect(ability).to be_able_to(:resend_confirmation_instruction, other_user) }
        end
      end

      describe "team's students or admin should be able to mark preferences to a conference" do
        context 'when user is a student from a team and try to update conference preferences' do

          let!(:conference_preference) { create(:conference_preference, :student_preference) }
          let!(:user) { conference_preference.team.students.first }

          it 'allows marking of conference preference' do
            expect(ability).to be_able_to(:crud, conference_preference)
          end

          context 'when user is admin' do
            let!(:organiser_role) { create(:organizer_role, user: user)}
            it "should be able to crud conference preference" do
              expect(subject).to be_able_to(:crud, conference_preference)
            end
          end
        end

        context 'when different users' do
          let!(:other_user) { create(:user)}
          let!(:conference_preference) { create(:conference_preference, team: team)}
          it { expect(ability).not_to be_able_to(:crud, other_user) }

        end
      end

      describe "just orga members, team's supervisor and team's students should be able to see offered conference for a team" do
        let(:user) { build(:student)}

        context 'when the user is an student of another team' do
          it { expect(ability).not_to be_able_to(:see_offered_conferences, Team.new) }
        end

        context 'when the user is a supervisor of another team' do
          before do
           allow(user).to receive(:supervisor?).and_return(true)
         end
          it { expect(ability).not_to be_able_to(:see_offered_conferences, Team.new) }
        end

        context "when the user is a team's student" do
          it { expect(ability).to be_able_to(:see_offered_conferences, Team.new(students: [user])) }
        end

        context "when the user is a team's supervisor" do
          it { expect(ability).to be_able_to(:see_offered_conferences, Team.new(supervisors: [user])) }
        end

        context 'when the user is an admin' do
          before do
            allow(user).to receive(:admin?).and_return(true)
          end
          it { expect(ability).to be_able_to(:see_offered_conferences, Team.new) }
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
        let!(:user) { create(:student) }

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

        context 'when not confirmed' do
          let!(:user) { create :student, confirmed_at: nil }
          let(:team) { create(:team) }

          it 'does not allow to create teams' do
            expect(subject).not_to be_able_to :create, Team.new
          end

          it 'does not allow to join teams' do
            expect(subject).not_to be_able_to :join, team
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

            it 'allows update conferences on own team' do
              expect(subject).to be_able_to :update_conference_preferences, student_team
            end

            it 'does not allow update conference preferences for other teams' do
              expect(subject).not_to be_able_to :update_conference_preferences, Team.new
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

    context 'working with projects' do
      let!(:user) { create(:user) }

      context 'crud' do

        it 'can be edited when I am an admin' do
          create(:organizer_role, user: user)
          expect(subject).to be_able_to :crud, Project.new
        end

        it 'can be edited if I am the project submitter' do
          expect(subject).to be_able_to :crud, Project.new(submitter: user)
        end

        it 'cannot be edited if my account is not confirmed' do
          user.confirmed_at = nil
          user.save
          expect(subject).not_to be_able_to :crud, Project.new(submitter: user)
        end

      end

      context 'create' do

        it 'can be created if I am confirmed' do
          expect(subject).to be_able_to :create, Project.new
        end

        it 'cannot be created if I am not confirmed' do
          user.confirmed_at = nil
          user.save
          expect(subject).not_to be_able_to :create, Project.new
        end

      end

    end

  end

  context 'to join helpdesk team' do
    let(:user) { create(:helpdesk) }
    let(:team) { create(:team) }

    it 'should be logged in' do
      expect(ability.signed_in?(user)).to eql true
    end

    it 'should not be part of existing team' do
      expect(ability.on_team?(user, team)).to eql false
    end

    it 'should be able to join helpdesk team' do
      helpdesk_team = create(:team, :helpdesk)
      expect(ability).to be_able_to(:join, helpdesk_team)
    end
  end

  context 'Crud Conferences' do
    let!(:user) { create(:user) }

    it 'permit crud conference when user is a current student' do
      create :student_role, user: user
      expect(ability).to be_able_to(:crud, Conference.new)
    end

    it 'permit crud conference when user is an organizer' do
      create :organizer_role, user: user
      expect(ability).to be_able_to(:crud, Conference.new)
    end
  end
end
