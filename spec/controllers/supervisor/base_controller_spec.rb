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
     end
   end
end
