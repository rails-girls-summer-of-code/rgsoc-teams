require 'spec_helper'

describe UsersController do
  render_views

  let(:valid_attributes) { build(:user).attributes.except('github_id', 'avatar_url', *User.immutable_attributes.map(&:to_s)) }
  let(:valid_session)    { { "warden.user.user.key" => session["warden.user.user.key"] } }

  describe "GET index" do
    it "assigns all users that have any roles assigned as @users" do
      student  = create(:student)
      coach = create(:coach)
      get :index, { params: {} }, valid_session
      expect(assigns(:users).to_a).to include(coach) && include(student)
    end

    it 'will not show email addresses for guests' do
      user = FactoryGirl.create(:user, hide_email: false)
      get :index, { params: {} }, {}
      expect(response.body).not_to include user.email
    end

    context 'with sorting' do
      it 'sorts by team' do
        get :index, params: { sort: 'team' }
        expect(response).to render_template 'index'
      end
    end

    context 'with user logged in' do
      it 'will not show email addresses of those who opted out' do
        sign_in create(:student)
        user = FactoryGirl.create(:student, hide_email: false)
        user_opted_out = FactoryGirl.create(:user, hide_email: true)
        get :index, { params: {} }, valid_session
        expect(response.body).to include user.email
        expect(response.body).not_to include user_opted_out.email
      end
    end

    it 'shows user impersonation links when in development' do
      user = create(:student)
      get :index, { params: {} }, {}
      expect(response.body).to include impersonate_user_path(user)
    end

    it 'does not show user impersonation links when in production' do
      allow(Rails).to receive(:env).and_return('production'.inquiry)
      user = create(:student)
      get :index, { params: {} }, {}
      expect(response.body).not_to include impersonate_user_path(user)
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = create(:user)
      get :show, { params: { id: user.to_param } }, valid_session
      expect(assigns(:user)).to eq(user)
    end

    it 'shows the user impersonation link when in development' do
      user = create(:user)
      get :show, { params: { id: user.to_param } }, {}
      expect(response.body).to include impersonate_user_path(user)
    end

    it 'does not show the user impersonation link when in production' do
      allow(Rails).to receive(:env).and_return('production'.inquiry)
      user = create(:user)
      get :show, { params: { id: user.to_param } }, {}
      expect(response.body).not_to include impersonate_user_path(user)
    end
  end

  describe "GET edit" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      it "assigns the requested user as @user" do
        get :edit, { params: { id: user.to_param } }, valid_session
        expect(assigns(:user)).to eq(user)
      end
    end

    context "another user's profile" do
      let(:another_user) { FactoryGirl.create(:user) }

      it "redirects to the homepage" do
        get :edit, { params: { id: another_user.to_param } }, valid_session
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      describe "with valid params" do
        it "updates the requested user" do
          expect_any_instance_of(User).to receive(:update_attributes).with(ActionController::Parameters.new({ 'name' => 'Trung Le' }).permit(:name))
          put :update, { params: { id: user.to_param, user: { 'name' => 'Trung Le' } } }, valid_session
        end

        it "assigns the requested user as @user" do
          put :update, { params: { id: user.to_param, user: valid_attributes } }, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to the user" do
          put :update, { params: { id: user.to_param, user: valid_attributes } }, valid_session
          expect(response).to redirect_to(user)
        end
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          allow_any_instance_of(User).to receive(:save).and_return(false)
          put :update, { params: { id: user.to_param, user: { 'name' => 'invalid value' } } }, valid_session
          expect(assigns(:user)).to eq(user)
        end

        it "re-renders the 'edit' template" do
          allow_any_instance_of(User).to receive(:save).and_return(false)
          put :update, { params: { id: user.to_param, user: { 'name' => 'invalid value' } } }, valid_session
          expect(response).to render_template("edit")
        end
      end

      context "another user's profile" do
        let!(:another_user) { FactoryGirl.create(:user) }

        it "does not update the requested user" do
          expect_any_instance_of(User).not_to receive(:update_attributes)
          put :update, { params: { id: another_user.to_param, user: { 'name' => 'Trung Le' } } }, valid_session
        end

        it "redirects the user to the homepage" do
          put :update, { params: { id: another_user.to_param, user: valid_attributes } }, valid_session
          expect(response).to redirect_to(root_url)
        end
      end
    end
  end

  describe 'PATCH update' do

    let(:valid_attributes) { { application_about: "lorem ipsum" } }

    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    context 'their own profile' do
      it 'updates the profile and redirects' do
        patch :update, { params: { id: user.id, user: valid_attributes } }
        expect(response).to redirect_to user
      end
    end
  end

  describe "DELETE destroy" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      it "destroys the requested user" do
        expect {
          delete :destroy, { params: { id: user.to_param } }, valid_session
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, { params: { id: user.to_param } }, valid_session
        expect(response).to redirect_to(users_url)
      end
    end

    context "another user's profile" do
      let(:another_user) { FactoryGirl.create(:user) }

      it "doesn't destroy the requested user" do
        expect {
          delete :destroy, { params: { id: another_user.to_param } }, valid_session
        }.to change(User, :count).by(1)
      end

      it "redirects to the homepage" do
        delete :destroy, { params: { id: another_user.to_param } }, valid_session
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST impersonate' do
    let(:user) { create(:user) }
    let(:impersonated_user) { create(:user) }
    before { sign_in user }

    it 'changes the current_user' do
      post :impersonate, { params: { id: impersonated_user.id } }
      expect(controller.current_user).to eq impersonated_user
    end

    it 'redirects to users#index' do
      post :impersonate, { params: { id: impersonated_user.id } }
      expect(response).to redirect_to users_path
      expect(flash[:notice]).to include "Now impersonating #{impersonated_user.name}"
    end
  end
end
