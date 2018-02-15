require 'spec_helper'

RSpec.describe Organizers::TeamsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:team) { create(:team, :in_current_season, kind: nil) }

  let(:valid_attributes) { build(:team).attributes.merge(roles_attributes: [{ name: 'coach', github_handle: 'tobias' }]) }

  before do
    user.roles.create(name: 'student', team: team)
  end

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      let!(:full_time_team) { create :team, :in_current_season, kind: 'full_time' }

      it 'assigns only selected teams as @teams' do
        get :index
        expect(assigns(:teams)).to match_array [full_time_team]
      end

      it 'assigns all teams as @teams when requested' do
        get :index, params: { filter: 'all' }
        expect(assigns(:teams)).to match_array [full_time_team, team]
      end
    end

    describe "GET show" do
      it "assigns the requested team as @team" do
        get :show, params: { id: team.to_param }
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
        get :edit, params: { id: team.to_param }
        expect(assigns(:team)).to eq(team)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Team" do
          params = { team_id: team.to_param, team: valid_attributes }
          expect { post :create, params: params }.to change(Team, :count).by(1)
        end

        it "assigns a newly created team as @team" do
          post :create, params: { team_id: team.to_param, team: valid_attributes }
          expect(assigns(:team)).to be_a(Team)
          expect(assigns(:team)).to be_persisted
        end

        it "redirects to the created team" do
          post :create, params: { team_id: team.to_param, team: valid_attributes }
          expect(response).to redirect_to [:organizers, assigns(:team)]
        end

        it 'sets the current season' do
          post :create, params: { team_id: team.to_param, team: valid_attributes }
          expect(assigns(:team).season.name).to eql Date.today.year.to_s
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested team" do
          expect_any_instance_of(Team).to receive(:update_attributes).with(ActionController::Parameters.new({ 'name' => 'Blue' }).permit(:name))
          put :update, params: { id: team.to_param, team: { 'name' => 'Blue' } }
        end

        it "assigns the requested team as @team" do
          put :update, params: { id: team.to_param, team: valid_attributes }
          expect(assigns(:team)).to eq(team)
        end

        it "redirects to the team" do
          put :update, params: { id: team.to_param, team: valid_attributes }
          expect(response).to redirect_to [:organizers, team]
        end
      end

      describe "with invalid params" do
        it "assigns the team as @team" do
          allow_any_instance_of(Team).to receive(:save).and_return(false)
          put :update, params: { id: team.to_param, team: { 'name' => 'invalid value' } }
          expect(assigns(:team)).to eq(team)
        end

        it "re-renders the 'edit' template" do
          allow_any_instance_of(Team).to receive(:save).and_return(false)
          put :update, params: { id: team.to_param, team: { 'name' => 'invalid value' } }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "PATCH update" do
      before { sign_in user}

      context "assign conference attendance" do
        let(:offer) { create(:conference_attendance) }
        let(:team) { offer.team }
        let!(:team_params) do
          build(:team).attributes.merge(conference_attendances_attributes: {
            '0' => {
              conference_id: offer.conference.id, orga_comment: "commment"
            }
          })
        end

        it 'orga members can assign conference offer for a team' do
          expect {
              patch :update, params: { id: team.id, team: team_params }
            }.to change { team.conference_attendances.count }.by 1
        end
      end
    end

    describe "DELETE destroy" do
      context "their own team" do
        let(:params) { { id: team.to_param } }

        it "destroys the requested team" do
          expect { delete :destroy, params: params }.to change(Team, :count).by(-1)
        end

        it "redirects to the team list" do
          delete :destroy, params: params
          expect(response).to redirect_to organizers_teams_url
        end
      end

    end
  end
end
