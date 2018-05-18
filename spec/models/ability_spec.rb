require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user){ nil }
  let(:other_user) { create(:user) }

  describe "Guest User" do
    it_behaves_like "can view public pages"
    it_behaves_like "can not modify things on public pages"
    it_behaves_like "can not create new user"
    it_behaves_like "can not comment"
    it_behaves_like "has no access to other user's accounts"
    it_behaves_like "can not read role restricted or owner restricted pages"
  end

  describe "Logged in user, not confirmed" do
    let(:user) { build_stubbed(:user, :unconfirmed) }

    it_behaves_like 'same as guest user'
    it_behaves_like "can modify own account"
  end

  describe "Confirmed user" do
    let!(:user) { create(:user) }

    it_behaves_like "same as logged in user"
    it_behaves_like "can create a Project"
    it_behaves_like "can see mailings list too"
    it_behaves_like "can read mailings sent to them"
    it_behaves_like "can comment now" # not implemented; false positives; needs work
    it { expect(subject).to be_able_to([:join, :create], Team) }

    describe "Team" do
      let(:current_team) { create(:team, :in_current_season) }
      let(:other_team)  { build_stubbed(:team, :in_current_season) }
      let(:future_team) { build(:team, season: Season.succ )}
      let(:old_team) { build_stubbed(:team, season: create(:season, :past)) }

      describe 'All members' do
        # must be true for all roles but student; can that be stubbed or something?
        before { create :coach_role, team: current_team, user: user }

        it_behaves_like "same public features as confirmed user"
        it { expect(subject).to be_able_to [:update, :destroy], current_team }
        it { expect(subject).not_to be_able_to [:update, :destroy], other_team}
      end

      describe "Student" do
        let(:new_team) {build(:team, :in_current_season)}

        # TODO FIX BUG [reveiled by PR 997]
        # the test for creating a second team is passing in team_spec because the validation kicks in on :submit
        # The ability _should_ prevent access to the new form in the first place.
        # There are some things wonky with the cancancan implementation.
        # To be fixed in a separate issue
        # These tests show the intended behaviour after the fix.

        context "with a student role from an earlier season" do
          before {create :student_role, team: old_team, user: user}

          it "can create their first team" do
            expect(subject).to be_able_to(:create, new_team)
          end
        end

        context "with a student role in the current season" do
          before { create :student_role, team: current_team, user: user }

          it 'cannot create a second team in current_season' do
            pending 'fails; it is tested in team_spec.rb:33, and that passes. See bug description above ^'
            expect(subject).not_to be_able_to(:create, new_team)
          end

          it 'can create a team for next season' do
            expect(subject).to be_able_to :create, future_team
          end

          it_behaves_like "same public features as confirmed user"
          it { expect(subject).to be_able_to(:create, Conference) }
        end
      end

      describe "Supervisor" do
        let(:other_user) { create(:user) }
        let(:other_team_user) { create(:user) }

        before do
          allow(user).to receive(:supervisor?).and_return(true)
        end

        context "when viewing user information" do

          # FIXME Implementation
          # It turns out that the `can? :read users_info` and `can? :read_email` are both view helpers
          # (And they overlap)
          # With the correct implementation of Cancancan, they are redundant.
          # See issue #1001
          # These new specs should pass with the correct implementation

          it_behaves_like "same public features as confirmed user"

          before do
            other_user.update!(hide_email: true)
            other_team_user.update!(hide_email: true)
          end

          it "can read email address of team members in current season, even when hidden" do
            pending 'fails; fix in separate issue'
            expect(subject).to receive(:supervises?).with(other_user, user).and_return true
            expect(subject).to be_able_to(:read, other_user.email)
          end

          it 'cannot read email of other users' do
            expect(subject).not_to be_able_to(:read, other_team_user.email)
          end
        end
      end
    end

    describe "Project Submitter" do
      let(:old_project) { build_stubbed(:project, submitter: user) }
      let(:other_project) { build_stubbed(:project, submitter: other_user) }
      let(:same_season_project) { build :project, :in_current_season, submitter: user }

      it_behaves_like "same public features as confirmed user"
      it { expect(subject).to be_able_to([:update, :destroy], Project.new(submitter: user)) }
      it { expect(subject).to be_able_to(:use_as_template, old_project) }
      it { expect(subject).not_to be_able_to(:use_as_template, other_project) }
      it { expect(subject).not_to be_able_to :use_as_template, same_season_project }
    end
  end

  describe "Admin" do
    let(:user) { create(:user) }
    let(:other_user) { build_stubbed(:user, hide_email: true) }

    before { allow(user).to receive(:admin?) { true } }

    it_behaves_like "can not create new user"
    # it "has access to almost everything else"
    # Only test the most exclusive and the most sensitive:
    it { expect(subject).to be_able_to(:crud, Team) }
    it { expect(subject).to be_able_to([:read, :update, :destroy], User) }
    it { expect(subject).to be_able_to(:read_email, other_user) }
    it { expect(subject).to be_able_to(:read, :users_info, other_user) }
  end



  ############# OLD SPECS ################

  context 'ability' do
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
        # not testing what it means to test
        xit { expect(ability).not_to be_able_to(:crud, other_user) }
      end
    end

    describe "just orga members, team's supervisor and team's students should be able to see offered conference for a team" do
      let(:user) { create(:student, confirmed_at: Date.yesterday)}

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

    describe 'operations on teams' do
      let(:team) { create :team }

      context 'when user student' do
        let!(:user) { create :student }

        context 'when in team for season' do
          before { create :student_role, team: student_team, user: user }
          let(:student_team) { create(:team, :in_current_season) }

          it 'allows update conferences on own team' do
            expect(subject).to be_able_to :update_conference_preferences, student_team
          end

          it 'does not allow update conference preferences for other teams' do
            expect(subject).not_to be_able_to :update_conference_preferences, Team.new
          end
        end
      end
    end


    context 'to join helpdesk team' do
      let(:user) { create(:helpdesk) }
      let(:team) { create(:team) }

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
        # but they shouldn't be able to crud? Only create.
        # expect(ability).to be_able_to(:crud, Conference.new)
        expect(ability).to be_able_to(:create, Conference.new)
      end

      it 'permit crud conference when user is an organizer' do
        create :organizer_role, user: user
        expect(ability).to be_able_to(:crud, Conference.new)
      end
    end
  end
end
