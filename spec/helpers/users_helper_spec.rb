require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe "#teams_for" do
    let(:user) { create :user }
    let(:invisible_team) { create :team, invisible: true, kind: nil }
    let(:visible_team) { create :team, invisible: false, kind: nil }
    let(:role_name) { 'student' }

    before do
      create(:role, name: 'student', user: user, team: invisible_team)
      create(:role, name: 'student', user: user, team: visible_team)
    end

    context 'user signed in is viewing own teams' do
      before do
        allow(self).to receive(:current_user).and_return(user)
      end

      it 'returns all teams' do
        expect(teams_for user).to contain_exactly(invisible_team, visible_team)
      end
    end

    context 'user not signed in is viewing teams' do
      before do
        allow(self).to receive(:current_user).and_return(nil)
      end

      it 'returns only visible teams' do
        expect(teams_for user).to contain_exactly(visible_team)
      end
    end
  end
end
