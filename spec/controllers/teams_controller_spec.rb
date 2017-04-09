require 'spec_helper'
require 'cancan/matchers'

RSpec.describe TeamsController do
  render_views

  include_context 'with user logged in'

  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:current_user) { user }

  let(:valid_attributes) { build(:team).attributes.merge(roles_attributes: [{ name: 'coach', github_handle: 'tobias' }]) }

  before do
    user.roles.create(name: 'student', team: team)
  end

  describe "GET index" do
    context 'before acceptance letters are sent' do
      let(:last_season)      { Season.create name: Date.today.year-1 }
      let!(:invisble_team)   { create :team, :in_current_season, kind: nil, invisible: true }
      let!(:unaccepted_team) { create :team, :in_current_season, kind: nil}
      let!(:last_years_team) { create :team, kind: 'sponsored', season: last_season }

      before do
        Season.current.update acceptance_notification_at: 1.day.from_now
      end

      it 'displays all of this season\'s team except the invisible ones' do
        get :index
        expect(assigns(:teams)).to match_array [unaccepted_team]
      end

    end

    context 'with sorting' do
      it 'sorts by created_at' do
        get :index, params: { sort: 'created_at' }
        expect(response).to render_template 'index'
      end
    end

    context 'after acceptance letters have been sent' do
      let(:last_season)      { Season.create name: Date.today.year-1 }
      let!(:voluntary_team)  { create :team, :in_current_season, kind: 'voluntary' }
      let!(:sponsored_team)  { create :team, :in_current_season, kind: 'sponsored' }
      let!(:unaccepted_team) { create :team, :in_current_season, kind: nil}
      let!(:last_years_team) { create :team, kind: 'sponsored', season: last_season }

      before do
        Season.current.update acceptance_notification_at: 1.day.ago
      end

      it 'only displays this season\'s accepted teams' do
        get :index
        expect(response).to be_success
        expect(assigns(:teams)).to match_array [voluntary_team, sponsored_team]
      end

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
    context "their own team" do
      let(:team) { FactoryGirl.create(:team) }

      it "assigns the requested team as @team" do
        get :edit, params: { id: team.to_param }
        expect(assigns(:team)).to eq(team)
        expect(response).to be_success
      end
    end

    context "someone else's team" do
      let(:another_team) { FactoryGirl.create(:team) }

      it "redirects to the homepage" do
        get :edit, params: { id: another_team.to_param }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "POST create" do
    before { sign_in user }

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
        expect(response).to redirect_to(assigns(:team))
      end

      it 'sets the current season' do
        post :create, params: { team_id: team.to_param, team: valid_attributes }
        expect(assigns(:team).season.name).to eql Date.today.year.to_s
      end

      context 'given the team is comprised of two students' do
        let(:first_student) { FactoryGirl.create(:user) }
        let(:second_student) { FactoryGirl.create(:user) }
        let(:team) { FactoryGirl.create(:team) }
        let(:current_user) { first_student }

        let(:valid_attributes) { build(:team).attributes.merge(roles_attributes: [{ name: 'student', github_handle: first_student.github_handle }, { name: 'student', github_handle: second_student.github_handle }]) }

        it 'sets the state as confirmed' do
          post :create, params: { team_id: team.to_param, team: valid_attributes }
          expect(assigns(:team)).to be_confirmed
        end
      end
    end
  end

  describe "PATCH update" do
    before { sign_in user }

    context "their own team" do
      let(:team) { FactoryGirl.create(:team) }

      describe "with valid params" do
        it "updates the requested team" do
          expect_any_instance_of(Team).to receive(:update_attributes).with(ActionController::Parameters.new({ 'name' => 'Blue' }).permit(:name))
          patch :update, params: { id: team.to_param, team: { 'name' => 'Blue' } }
        end

        it "assigns the requested team as @team" do
          patch :update, params: { id: team.to_param, team: valid_attributes }
          expect(assigns(:team)).to eq(team)
        end

        it "redirects to the team" do
          patch :update, params: { id: team.to_param, team: valid_attributes }
          expect(response).to redirect_to(team)
        end

        context 'with nested role attributes' do
          let(:github_handle) { valid_attributes[:roles_attributes].first[:github_handle] }

          let(:randomize_case) do
            ->(string) do
              string.each_char.inject('') { |str, c| str << c.send([:downcase, :upcase][rand(2)]) }
            end
          end

          it 'creates a new user from github_handle' do
            expect {
              patch :update, params: { id: team.to_param, team: valid_attributes }
            }.to change { User.count }.by 1

            expect(User.last.github_handle).to eql github_handle
          end

          it 'finds an existing user by case-insensitive github_handle' do
            existing_user = create :user, github_handle: randomize_case.(github_handle)
            expect {
              patch :update, params: { id: team.to_param, team: valid_attributes }
            }.not_to change { User.count }

            expect(Role.last.user).to eql existing_user
          end

        end
      end

      describe "with invalid params" do
        it "assigns the team as @team" do
          allow_any_instance_of(Team).to receive(:save).and_return(false)
          patch :update, params: { id: team.to_param, team: { 'name' => 'invalid value' } }
          expect(assigns(:team)).to eq(team)
        end

        it "re-renders the 'edit' template" do
          allow_any_instance_of(Team).to receive(:save).and_return(false)
          patch :update, params: { id: team.to_param, team: { 'name' => 'invalid value' } }
          expect(response).to render_template("edit")
        end
      end

      context "another team" do
        let(:another_team) { FactoryGirl.create(:team) }

        it "does not update the requested team" do
          expect_any_instance_of(Team).not_to receive(:update_attributes)
          patch :update, params: { id: another_team.to_param, team: { 'name' => 'Blue' } }
        end

        it "redirects the team to the homepage" do
          patch :update, params: { id: another_team.to_param, team: valid_attributes }
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before { sign_in user }

    context "their own team" do
      let(:params) { { id: team.to_param } }

      it "destroys the requested team" do
        expect { delete :destroy, params: params }.to change(Team, :count).by(-1)
      end

      it "redirects to the team list" do
        delete :destroy, params: params
        expect(response).to redirect_to(teams_url)
      end
    end

    context "another team's profile" do
      let(:another_team) { FactoryGirl.create(:team) }
      let(:params)       { { id: another_team.to_param } }

      it "doesn't destroy the requested team" do
        expect { delete :destroy, params: params }.to change(Team, :count).by(1)
      end

      it "redirects to the homepage" do
        delete :destroy, params: params
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
