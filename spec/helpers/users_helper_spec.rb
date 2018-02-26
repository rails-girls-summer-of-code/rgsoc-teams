require 'rails_helper'
require 'cancan/matchers'

RSpec.describe UsersHelper, type: :helper do

  describe "#teams_for?" do
    let!(:user) { create :user }
    let!(:invisible_team) { create :team, invisible: true, kind: nil }
    let(:role_name) { 'student' }

    before do
      invisible_team.attributes = { roles_attributes: [{ name: role_name, user_id: user.id }] }
      invisible_team.save!
    end

    context 'user signed in is viewing own teams' do
      before do
        allow(self).to receive(:current_user).and_return(user)
      end

      it 'returns all teams' do
        expect(teams_for user).to eq([invisible_team])
      end
    end

    context 'user not signed in is viewing teams' do
      before do
        allow(self).to receive(:current_user).and_return(nil)
      end

      it 'returns only visible teams' do
        expect(teams_for user).to eq([])
      end
    end
  end
end
