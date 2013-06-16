require 'spec_helper'

describe RolesController do
  let(:valid_attributes) { build(:role).attributes.merge(github_handle: 'someone') }
  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new role as @role" do
      team = create(:team)
      get :new, { team_id: team.to_param }, valid_session
      assigns(:role).should be_a_new(Role)
    end
  end

  describe "POST create" do
    it "creates a new Role" do
      team = create(:team)
      expect {
        post :create, { team_id: team.to_param, role: valid_attributes }, valid_session
      }.to change(Role, :count).by(1)
    end

    it "redirects to the team view" do
      team = create(:team)
      post :create, { team_id: team.to_param, role: valid_attributes }, valid_session
      response.should redirect_to(assigns(:team))
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested role" do
      role = create(:role)
      expect {
        delete :destroy, { team_id: role.to_param, id: role.to_param }, valid_session
      }.to change(Role, :count).by(-1)
    end

    it "redirects to the team view" do
      role = create(:role)
      delete :destroy, { team_id: role.to_param, id: role.to_param }, valid_session
      response.should redirect_to(assigns(:team))
    end
  end
end

