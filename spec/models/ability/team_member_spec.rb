require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]
RSpec.describe Ability, type: :model do

  let(:user) { create(:user) }
  subject(:ability) { Ability.new(user) }

  let(:other_user) { build_stubbed(:user, hide_email: true) }

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
          allow(subject).to receive(:supervises?).with(other_user, user).and_return true
          expect(subject).to be_able_to(:read, other_user.email)
        end

        it 'cannot read email of other users' do
          expect(subject).not_to be_able_to(:read, other_team_user.email)
        end
      end
    end
  end
end
