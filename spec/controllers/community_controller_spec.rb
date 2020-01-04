require 'rails_helper'

RSpec.describe CommunityController, type: :controller do
  render_views

  let(:valid_attributes) { build(:user).attributes.except('github_id', 'avatar_url', *User.immutable_attributes.map(&:to_s)) }

  describe "GET index" do
    it "assigns all users that have any roles assigned as @users" do
      student = create(:student)
      coach = create(:coach)
      get :index
      expect(assigns(:users).to_a).to include(coach) && include(student)
    end

    it 'will not show email addresses for guests' do
      user = create(:user, hide_email: false)
      get :index
      expect(response.body).not_to include user.email
    end

    context 'with sorting' do
      it 'sorts by team' do
        get :index, params: { sort: 'team' }
        expect(response).to render_template 'index'
      end
    end

    context 'with filtering' do
      it 'filters by role' do
        get :index, params: { role: 'student' }
        expect(response).to render_template 'index'
      end

      it 'filters by interest' do
        get :index, params: { interest: 'pair' }
        expect(response).to render_template 'index'
      end
    end

    context 'with user logged in' do
      before(:each) do
        sign_in create(:student)
      end

      it 'will not show email addresses of those who opted out' do
        user = create(:student, hide_email: false)
        user_opted_out = create(:user, hide_email: true)
        get :index
        expect(response.body).to include user.email
        expect(response.body).not_to include user_opted_out.email
      end

      it 'shows user impersonation links when in development' do
        other_user = create(:student)
        get :index
        expect(response.body).to include impersonate_user_path(other_user)
      end

      it 'does not show user impersonation links when in production' do
        allow(Rails).to receive(:env).and_return('production'.inquiry)
        other_user = create(:student)
        get :index
        expect(response.body).not_to include impersonate_user_path(other_user)
      end
    end

    context 'when impersonating' do
      it 'shows a Stop Impersonation link instead of Sign out' do
        sign_in create(:student)
        other_user = create(:student)
        controller.impersonate_user(other_user)
        get :index
        expect(response.body).not_to include sign_out_path
        expect(response.body).to include stop_impersonating_users_path
      end
    end
  end
end
