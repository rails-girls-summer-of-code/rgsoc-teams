require 'spec_helper'

RSpec.describe Orga::TeamsController do
  render_views

  let(:user) { create(:user) }
  let(:team) { create(:team) }

  let(:valid_attributes) { build(:team).attributes.merge(roles_attributes: [{ name: 'coach', github_handle: 'tobias' }], project_attributes: {name: 'project'}) }

  before do
    user.roles.create(name: 'student', team: team)
  end

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe "GET index" do
      it "assigns all teams as @teams" do
        get :index
        expect(assigns(:teams).to_a).to be == [team]
      end

    end

    describe "GET show" do
      it "assigns the requested team as @team" do
        get :show, id: team.to_param
        expect(assigns(:team)).to eql team
      end
    end

    describe "GET new" do
      it "assigns a new team as @team" do
        get :new
        expect(assigns(:team)).to be_a_new(Team)
      end
    end

    describe "GET edit" do
      it "assigns the requested team as @team" do
        get :edit, id: team.to_param
        expect(assigns(:team)).to eq(team)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Team" do
          params = { team_id: team.to_param, team: valid_attributes }
          expect { post :create, params }.to change(Team, :count).by(1)
        end

        it "assigns a newly created team as @team" do
          post :create, { team_id: team.to_param, team: valid_attributes }
          expect(assigns(:team)).to be_a(Team)
          expect(assigns(:team)).to be_persisted
        end

        it "redirects to the created team" do
          post :create, { team_id: team.to_param, team: valid_attributes }
          expect(response).to redirect_to(assigns(:team))
        end

        it 'sets the current season' do
          post :create, { team_id: team.to_param, team: valid_attributes }
          expect(assigns(:team).season.name).to eql Date.today.year.to_s
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested team" do
          expect_any_instance_of(Team).to receive(:update_attributes).with({ 'name' => 'Blue' })
          put :update, { id: team.to_param, team: { 'name' => 'Blue' } }
        end

        it "creates a project when team is selected" do
          put :update, { id: team.to_param, team: { project_attributes: { 'name' => 'Blue' } } }
          expect(team.reload.project.name).to eq('Blue')
        end

        it "assigns the requested team as @team" do
          put :update, { id: team.to_param, team: valid_attributes }
          expect(assigns(:team)).to eq(team)
        end

        it "redirects to the team" do
          put :update, { id: team.to_param, team: valid_attributes }
          expect(response).to redirect_to(team)
        end
      end

      describe "with invalid params" do
        it "assigns the team as @team" do
          allow_any_instance_of(Team).to receive(:save).and_return(false)
          put :update, { id: team.to_param, team: { 'name' => 'invalid value' } }
          expect(assigns(:team)).to eq(team)
        end

        it "re-renders the 'edit' template" do
          allow_any_instance_of(Team).to receive(:save).and_return(false)
          put :update, { id: team.to_param, team: { 'name' => 'invalid value' } }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      context "their own team" do
        let(:params) { { id: team.to_param } }

        it "destroys the requested team" do
          expect { delete :destroy, params }.to change(Team, :count).by(-1)
        end

        it "redirects to the team list" do
          delete :destroy, params
          expect(response).to redirect_to(teams_url)
        end
      end

    end
  end
end
