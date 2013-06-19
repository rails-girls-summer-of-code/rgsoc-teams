require 'spec_helper'
require 'cancan/matchers'

describe TeamsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }

  let(:valid_attributes) { build(:team).attributes }
  let(:valid_session)    { { "warden.user.user.key" => session["warden.user.user.key"] } }

  before :each do
    user.roles.create(name: 'student', team: team)
    sign_in user
  end

  describe "GET index" do
    it "assigns all teams as @teams" do
      get :index, {}, valid_session
      assigns(:teams).should eq([team])
    end
  end

  describe "GET show" do
    it "assigns the requested team as @team" do
      get :show, { id: team.to_param }, valid_session
      assigns(:team).should eq(team)
    end
  end

  describe "GET new" do
    it "assigns a new team as @team" do
      get :new, {}, valid_session
      assigns(:team).should be_a_new(Team)
    end
  end

  describe "GET edit" do
    context "their own team" do
      let(:team) { FactoryGirl.create(:team) }

      it "assigns the requested team as @team" do
        get :edit, { id: team.to_param }, valid_session
        assigns(:team).should eq(team)
      end
    end

    context "someone else's team" do
      let(:another_team) { FactoryGirl.create(:team) }

      it "redirects to the homepage" do
        get :edit, { id: another_team.to_param }, valid_session
        response.should redirect_to(root_url)
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Team" do
        params = { team_id: team.to_param, team: valid_attributes }
        expect { post :create, params, valid_session }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        post :create, { team_id: team.to_param, team: valid_attributes }, valid_session
        assigns(:team).should be_a(Team)
        assigns(:team).should be_persisted
      end

      it "redirects to the created team" do
        post :create, { team_id: team.to_param, team: valid_attributes }, valid_session
        response.should redirect_to(assigns(:team))
      end
    end
  end

  describe "PUT update" do
    context "their own team" do
      let(:team) { FactoryGirl.create(:team) }

      describe "with valid params" do
        it "updates the requested team" do
          Team.any_instance.should_receive(:update_attributes).with({ 'name' => 'Blue' })
          put :update, { id: team.to_param, team: { 'name' => 'Blue' } }, valid_session
        end

        it "assigns the requested team as @team" do
          put :update, { id: team.to_param, team: valid_attributes }, valid_session
          assigns(:team).should eq(team)
        end

        it "redirects to the team" do
          put :update, { id: team.to_param, team: valid_attributes }, valid_session
          response.should redirect_to(team)
        end
      end

      describe "with invalid params" do
        it "assigns the team as @team" do
          Team.any_instance.stub(:save).and_return(false)
          put :update, { id: team.to_param, team: { 'name' => 'invalid value' } }, valid_session
          assigns(:team).should eq(team)
        end

        it "re-renders the 'edit' template" do
          Team.any_instance.stub(:save).and_return(false)
          put :update, { id: team.to_param, team: { 'name' => 'invalid value' } }, valid_session
          response.should render_template("edit")
        end
      end

      context "another team" do
        let(:another_team) { FactoryGirl.create(:team) }

        it "does not update the requested team" do
          Team.any_instance.should_not_receive(:update_attributes)
          put :update, { id: another_team.to_param, team: { 'name' => 'Blue' } }, valid_session
        end

        it "redirects the team to the homepage" do
          put :update, { id: another_team.to_param, team: valid_attributes }, valid_session
          response.should redirect_to(root_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    context "their own team" do
      let(:params) { { id: team.to_param } }

      it "destroys the requested team" do
        expect { delete :destroy, params, valid_session }.to change(Team, :count).by(-1)
      end

      it "redirects to the team list" do
        delete :destroy, params, valid_session
        response.should redirect_to(teams_url)
      end
    end

    context "another team's profile" do
      let(:another_team) { FactoryGirl.create(:team) }
      let(:params)       { { id: another_team.to_param } }

      it "doesn't destroy the requested team" do
        expect { delete :destroy, params, valid_session }.to change(Team, :count).by(1)
      end

      it "redirects to the homepage" do
        delete :destroy, params, valid_session
        response.should redirect_to(root_url)
      end
    end
  end
end
