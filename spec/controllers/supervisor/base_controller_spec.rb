require 'spec_helper'

describe Supervisor::BaseController do
  describe 'access for supervisors only', type: :controller do
    let(:valid_session) { {} }
    let(:user) { FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }

    context "with team's supervisor logged in" do
      render_views
      before do
        user.roles.create(name: 'supervisor', team: team)
        sign_in user
      end

      after do
        sign_out user
      end

      it "should grant access to dashboard" do
        get '/supervisor/dashboard#index'
        expect(response).to be_success
        expect(response.status).to eq(200)
        expect(page).to have_content("Dashboard")
      end
    end

    context "denies access for users with another role" do
      let(:another_user)  { FactoryGirl.create(:user) }

      before do
        another_user.roles.create(name: 'coach', team: team)
        sign_in another_user
      end

        it 'should deny access to dashboard' do
          expect(response).to redirect_to '/'
        end
    end
  end
end
