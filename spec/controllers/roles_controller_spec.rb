require 'rails_helper'

RSpec.describe RolesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { build(:role, team: team).attributes }

  before :each do
    sign_in user
  end

  describe "GET new" do
    let(:team) { create(:team) }

    it "assigns a new role as @role" do
      get :new, params: { team_id: team.to_param }
      expect(assigns(:role)).to be_a_new(Role)
    end
  end

  describe "PUT confirm" do
    let(:team)    { create(:team) }

    context 'as a coach confirming my role' do
      let!(:role) { create(:role, name: 'coach', team: team, user: user) }

      it 'allows the role to be confirmed' do
        expect {
          put :confirm, params: { id: role.confirmation_token }
        }.to change { role.reload.state }.from('pending').to('confirmed')
        expect(response).to redirect_to(assigns(:team))
      end
    end
  end

  describe "POST create" do
    let(:team)    { create(:team) }
    let!(:params) { { team_id: team.to_param, role: valid_attributes.merge(github_handle: 'steve') } }

    context "on their own team" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      let(:randomize_case) do
        ->(string) do
          string.each_char.inject('') { |str, c| str << c.send([:downcase, :upcase][rand(2)]) }
        end
      end

      it "creates a new Role and a new User" do
        expect {
          expect { post :create, params: params }.to change(Role, :count).by(1)
        }.to change { User.count }.by(1)
      end

      it "redirects to the team view" do
        post :create, params: params
        expect(response).to redirect_to(assigns(:team))
      end

      it 'creates a new Role for existing user with case-insensitive github_handle' do
        existing   = create(:user)
        role_attrs = valid_attributes.merge(github_handle: randomize_case.call(existing.github_handle))

        expect {
          expect { post :create, params: params.merge(role: role_attrs) }.to change(Role, :count).by(1)
        }.not_to change { User.count }
        expect(Role.last.user).to eql existing
      end
    end

    context "someone else's team" do
      let(:another_user) { create(:user) }
      let!(:role)        { create(:role, name: 'student', team: team, user: another_user) }

      it "does not create the Role" do
        expect { post :create, params: params }.to_not change(Role, :count)
      end

      it "redirects to the root_url" do
        post :create, params: params
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
        expect { delete :destroy, params: params }.to change(Role, :count).by(-1)
      end

      it "redirects to the team view" do
        delete :destroy, params: params
        expect(response).to redirect_to(assigns(:team))
      end
    end

    context "someone else's role" do
      let(:another_user) { create(:user) }
      let!(:role)        { create(:role, name: 'student', team: team, user: another_user) }

      it "does not destroy the requested role" do
        expect { delete :destroy, params: params }.to_not change(Role, :count)
      end

      it "redirects to the root_url" do
        delete :destroy, params: params
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
