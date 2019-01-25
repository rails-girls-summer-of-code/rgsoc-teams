require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  let(:user) { create(:user) }
  subject(:ability) { Ability.new(user) }

  let(:other_user) { build_stubbed(:user, hide_email: true) }

  it { expect(subject).to be_able_to([:join, :create], Team) }
  it { expect(subject).to be_able_to(:read, Mailing, recipient: user) }

  describe "Team" do
    let(:current_team) { create(:team, :in_current_season) }
    let(:other_team)  { build_stubbed(:team, :in_current_season) }
    let(:future_team) { build(:team, season: Season.succ) }
    let(:old_team) { build_stubbed(:team, season: create(:season, :past)) }

    describe 'All members' do
      before { create :coach_role, team: current_team, user: user }

      it { expect(subject).to be_able_to [:update, :destroy], current_team }
      it { expect(subject).not_to be_able_to [:update, :destroy], other_team }
    end

    describe "Student" do
      let(:new_team) { build(:team, :in_current_season) }

      context "with a student role from an earlier season" do
        before { create :student_role, team: old_team, user: user }

        it "can create their first team" do
          expect(subject).to be_able_to(:create, new_team)
        end
      end

      context "with a student role in the current season" do
        before { create :student_role, team: current_team, user: user }

        it 'cannot create a second team in current_season' do
          expect(subject).not_to be_able_to(:create, new_team)
        end

        it 'can create a team for next season' do
          expect(subject).to be_able_to :create, future_team
        end

        it { expect(subject).to be_able_to(:create, ApplicationDraft) }

        it { expect(subject).to be_able_to(:create, Conference) }
      end
    end

    describe "Supervisor" do
      let(:team_member) { create(:user) }
      let(:user_in_other_team) { create(:user) }

      before do
        allow(user).to receive(:supervisor?).and_return(true)
      end

      context "when viewing user information" do
        # FIXME see issue #1001
        # The following specs should pass after fixing
        before do
          team_member.update!(hide_email: true)
          user_in_other_team.update!(hide_email: true)
        end

        it "can read email address of team members in current season, even when hidden" do
          pending 'fails; To be solved with issue #1001'
          allow(subject).to receive(:supervises?).with(team_member, user).and_return true
          expect(subject).to be_able_to(:read, team_member.email)
        end

        it 'cannot read email of other users' do
          expect(subject).not_to be_able_to(:read, user_in_other_team.email)
        end
      end
    end
  end
end
