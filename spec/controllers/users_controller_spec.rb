require 'spec_helper'

RSpec.describe UsersController do
  render_views

  let(:valid_attributes) { build(:user).attributes.except('github_id', 'avatar_url', *User.immutable_attributes.map(&:to_s)) }

  describe "GET index" do
    it "assigns all users that have any roles assigned as @users" do
      student  = FactoryGirl.create(:student)
      coach = FactoryGirl.create(:coach)
      get :index
      expect(assigns(:users).to_a).to include(coach) && include(student)
    end

    it 'will not show email addresses for guests' do
      user = FactoryGirl.create(:user, hide_email: false)
      get :index
      expect(response.body).not_to include user.email
    end

    context 'with sorting' do
      it 'sorts by team' do
        get :index, params: { sort: 'team' }
        expect(response).to render_template 'index'
      end
    end

    context 'with user logged in' do
      before(:each) do
        sign_in FactoryGirl.create(:student)
      end

      it 'will not show email addresses of those who opted out' do
        user = FactoryGirl.create(:student, hide_email: false)
        user_opted_out = FactoryGirl.create(:user, hide_email: true)
        get :index
        expect(response.body).to include user.email
        expect(response.body).not_to include user_opted_out.email
      end

      it 'shows user impersonation links when in development' do
        other_user = FactoryGirl.create(:student)
        get :index
        expect(response.body).to include impersonate_user_path(other_user)
      end

      it 'does not show user impersonation links when in production' do
        allow(Rails).to receive(:env).and_return('production'.inquiry)
        other_user = FactoryGirl.create(:student)
        get :index
        expect(response.body).not_to include impersonate_user_path(other_user)
      end
    end

    context 'when impersonating' do
      it 'shows a Stop Impersonation link instead of Sign out' do
        sign_in FactoryGirl.create(:student)
        other_user = FactoryGirl.create(:student)
        controller.impersonate_user(other_user)
        get :index
        expect(response.body).not_to include sign_out_path
        expect(response.body).to include stop_impersonating_users_path
      end
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end

    context 'with conferences' do
      let!(:preference_info) { FactoryGirl.create :conference_preference_info, :with_preferences }
      let(:user)        { preference_info.team.students.first }
      let(:conference)  { preference_info.conference_preferences.first.conference }

      context 'with conferences preferences orphans' do
        let!(:orphan) { FactoryGirl.create :conference_preference_info, :with_preferences }
        let!(:conference) { orphan.conference_preferences.first.conference }
        let!(:user) { orphan.team.members.first }

        before { orphan.conference_preferences.first.conference.destroy }

        # There are some stale conferences preferences records in the system since
        # attendences used to stick around when their conference was deleted
        it 'will not list conferences preferences w/o conference' do
          get :show, params: { id: user.to_param }
          expect(response).to be_success
          expect(response.body).not_to match conference.name
        end
      end
    end

    context 'with user logged in' do
      before(:each) do
        sign_in FactoryGirl.create(:student)
      end

      it 'shows the user impersonation link when in development' do
        other_user = FactoryGirl.create(:user)
        get :show, params: { id: other_user.to_param }
        expect(response.body).to include impersonate_user_path(other_user)
      end

      it 'does not show the user impersonation link when in production' do
        allow(Rails).to receive(:env).and_return('production'.inquiry)
        other_user = FactoryGirl.create(:user)
        get :show, params: { id: other_user.to_param }
        expect(response.body).not_to include impersonate_user_path(other_user)
      end
    end
  end

  describe "GET edit" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      it "assigns the requested user as @user" do
        get :edit, params: { id: user.to_param }
        expect(assigns(:user)).to eq(user)
      end
    end

    context "another user's profile" do
      let(:another_user) { FactoryGirl.create(:user) }

      it "redirects to the homepage" do
        get :edit, params: { id: another_user.to_param }
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

        context "and unconfirmed user" do
          let(:user) { FactoryGirl.create(:user, confirmed_at: nil) }

          it "sends an confirmation email if the user isn't confirmed yet and the email wasn't changed" do
            expect {
              put :update, params: { id: user.to_param, user: { name: 'Trung Le' } }
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end

          it "sends only one confirmation email if the user isn't confirmed yet and the email was changed" do
            expect {
              put :update, params: { id: user.to_param, user: { name: 'Trung Le', email: 'newmail@example.com' } }
            }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        it "updates the requested user" do
          expect_any_instance_of(User).to receive(:update_attributes).with(ActionController::Parameters.new({ name: 'Trung Le' }).permit(:name))
          put :update, params: { id: user.to_param, user: { name: 'Trung Le' } }
        end

        it "assigns the requested user as @user" do
          put :update, params: { id: user.to_param, user: valid_attributes }
          expect(assigns(:user)).to eq(user)
        end

        it "redirects to the user" do
          put :update, params: { id: user.to_param, user: valid_attributes }
          expect(response).to redirect_to(user)
        end
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          allow_any_instance_of(User).to receive(:save).and_return(false)
          put :update, params: { id: user.to_param, user: { name: 'invalid value' } }
          expect(assigns(:user)).to eq(user)
        end

        it "re-renders the 'edit' template" do
          allow_any_instance_of(User).to receive(:save).and_return(false)
          put :update, params: { id: user.to_param, user: { name: 'invalid value' } }
          expect(response).to render_template("edit")
        end
      end

      context "another user's profile" do
        let!(:another_user) { FactoryGirl.create(:user) }

        it "does not update the requested user" do
          expect_any_instance_of(User).not_to receive(:update_attributes)
          put :update, params: { id: another_user.to_param, user: { name: 'Trung Le' } }
        end

        it "redirects the user to the homepage" do
          put :update, params: { id: another_user.to_param, user: valid_attributes }
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
        patch :update, params: { id: user.id, user: valid_attributes }
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
          delete :destroy, params: { id: user.to_param }
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, params: { id: user.to_param }
        expect(response).to redirect_to(users_url)
      end
    end

    context "another user's profile" do
      let(:another_user) { FactoryGirl.create(:user) }

      it "doesn't destroy the requested user" do
        expect {
          delete :destroy, params: { id: another_user.to_param }
        }.to change(User, :count).by(1)
      end

      it "redirects to the homepage" do
        delete :destroy, params: { id: another_user.to_param }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST impersonate' do
    let(:user) { FactoryGirl.create(:user) }
    let(:impersonated_user) { FactoryGirl.create(:user) }
    before { sign_in user }

    it 'changes the current_user' do
      post :impersonate, params: { id: impersonated_user.id }
      expect(controller.current_user).to eq impersonated_user
    end

    it 'redirects to users#index' do
      post :impersonate, params: { id: impersonated_user.id }
      expect(response).to redirect_to users_path
      expect(flash[:notice]).to include "Now impersonating #{impersonated_user.name}"
    end
  end

  describe 'POST stop_impersonating' do
    let(:user) { FactoryGirl.create(:user) }
    let(:impersonated_user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      controller.impersonate_user(impersonated_user)
    end

    it 'changes the current_user' do
      post :stop_impersonating
      expect(controller.current_user).to eq user
    end

    it 'redirects to users#index' do
      post :stop_impersonating
      expect(response).to redirect_to users_path
      expect(flash[:notice]).to include "Impersonation stopped"
    end
  end

  describe 'POST resend_confirmation_instruction' do
    let(:user) { create(:user) }
    before do
      sign_in user
    end

    it 'resends the confirmation instruction' do
      expect_any_instance_of(User).to receive :send_confirmation_instructions
      post :resend_confirmation_instruction, params: { id: user.id }
    end
  end
end
