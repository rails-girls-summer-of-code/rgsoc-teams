require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }
  let(:other_user) { create(:user) }

  ############# OLD SPECS #####################
  # TODO Reorganize to /ability/-*role*-specs #

  context 'ability' do
    describe "team's students or admin should be able to mark preferences to a conference" do
      context 'when user is a student from a team and try to update conference preferences' do
        let!(:conference_preference) { create(:conference_preference, :student_preference) }
        let!(:user) { conference_preference.team.students.first }

        it 'allows marking of conference preference' do
          expect(ability).to be_able_to(:crud, conference_preference)
        end

        context 'when user is admin' do
          let!(:organiser_role) { create(:organizer_role, user: user) }
          it "should be able to crud conference preference" do
            expect(subject).to be_able_to(:crud, conference_preference)
          end
        end
      end

      context 'when different users' do
        let!(:other_user) { create(:user) }
        let!(:conference_preference) { create(:conference_preference, team: team) }
        # not testing what it means to test
        xit { expect(ability).not_to be_able_to(:crud, other_user) }
      end
    end

    describe "just orga members, team's supervisor and team's students should be able to see offered conference for a team" do
      let(:user) { create(:student, confirmed_at: Date.yesterday) }

      context 'when the user is an student of another team' do
        it { expect(ability).not_to be_able_to(:see_offered_conferences, Team.new) }
      end

      context 'when the user is a supervisor of another team' do
        before { allow(user).to receive(:supervisor?).and_return(true) }

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
        # changed into:
        expect(ability).to be_able_to(:create, Conference.new)
      end

      it 'permit crud conference when user is an organizer' do
        create :organizer_role, user: user
        expect(ability).to be_able_to(:crud, Conference.new)
      end
    end
  end
end
