require 'spec_helper'

describe RolesController do
  let(:user) { create(:user) }
  let(:valid_attributes) { build(:role, team: team).attributes }
  let(:valid_session)    { { "warden.user.user.key" => session["warden.user.user.key"] } }

  before :each do
    sign_in user
  end

  describe "GET new" do
    let(:team) { create(:team) }

    it "assigns a new role as @role" do
      get :new, { team_id: team.to_param }, valid_session
      expect(assigns(:role)).to be_a_new(Role)
    end
  end

  describe "PUT update" do
    let(:team)    { create(:team) }

    context 'as a coach confirming my role' do
      let!(:role) { create(:role, name: 'coach', team: team, user: user) }
      let!(:params) { { team_id: team.to_param, id: role.to_param, confirm: true } }

      it 'allows the role to be confirmed' do
        put :update, params, valid_session
        expect(response).to redirect_to(assigns(:team))
      end
    end
  end

  describe "POST create" do
    let(:team)    { create(:team) }
    let!(:params) { { team_id: team.to_param, role: valid_attributes.merge(github_handle: 'steve') } }

    context "on their own team" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      it "creates a new Role and a new User" do
        expect {
          expect { post :create, params, valid_session }.to change(Role, :count).by(1)
        }.to change { User.count }.by(1)
      end

      it "redirects to the team view" do
        post :create, params, valid_session
        expect(response).to redirect_to(assigns(:team))
      end

      it 'create a new Role for existing user' do
        existing   = create(:user)
        role_attrs = valid_attributes.merge(github_handle: existing.github_handle)

        expect {
          expect { post :create, params.merge(role: role_attrs), valid_session }.to change(Role, :count).by(1)
        }.not_to change { User.count }
        expect(Role.last.user).to eql existing
      end
    end

    context "someone else's team" do
      let(:another_user) { create(:user) }
      let!(:role)        { create(:role, name: 'student', team: team, user: another_user) }

      it "does not create the Role" do
        expect { post :create, params, valid_session }.to_not change(Role, :count)
      end

      it "redirects to the root_url" do
        post :create, params, valid_session
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "DELETE destroy" do
    let(:team)   { create(:team) }
    let(:params) { { id: role.to_param, team_id: team.id } }

    context "their own role" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      it "destroys the requested role" do
        expect { delete :destroy, params, valid_session }.to change(Role, :count).by(-1)
      end

      it "redirects to the team view" do
        delete :destroy, params, valid_session
        expect(response).to redirect_to(assigns(:team))
      end
    end

    context "someone else's role" do
      let(:another_user) { create(:user) }
      let!(:role)        { create(:role, name: 'student', team: team, user: another_user) }

      it "does not destroy the requested role" do
        expect { delete :destroy, params, valid_session }.to_not change(Role, :count)
      end

      it "redirects to the root_url" do
        delete :destroy, params, valid_session
        expect(response).to redirect_to(root_url)
      end
    end
  end
end

