require 'rails_helper'
require 'cancan/matchers'

RSpec.describe JoinController, type: :controller do
  render_views

  include_context 'with user logged in'

  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:current_user) { user }
  let(:role) { team.roles.build(user: user, name: 'helpdesk') }

  describe "GET new" do
    before { sign_in user }

    it "assigns team as @team" do
      get :new, params: { team_id: team.to_param }
      expect(assigns(:team)).to eq(team)
    end
  end

  describe "POST create" do
    before { sign_in user }

    describe "with valid params" do
      let(:team) { create(:team, :helpdesk) }

      it "adds the current user to the team" do
        post :create, params: { team_id: team.to_param }
        expect(team.roles).to include(role)
      end

      it "redirects to the user's profile" do
        post :create, params: { team_id: team.to_param }
        expect(response).to redirect_to(edit_user_url(user))
      end
    end

    describe "with invalid params" do
      it "redirects to to the previous page" do
        post :create, params: { team_id: team.to_param }
        expect(response).to redirect_to(teams_url)
      end
    end
  end
end
