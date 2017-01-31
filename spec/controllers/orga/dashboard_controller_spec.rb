require 'spec_helper'

RSpec.describe Orga::DashboardController, :focus do
  render_views

  describe '#GET index' do
    context 'without admin role' do
      it 'redirects to root patg' do
        sign_in create(:student)
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'with admin role' do
      before do
        user = create(:supervisor)
        create(:organizer_role, user: user)
        sign_in user
        get :index
      end

      it 'renders the dashboard' do
        expect(response).to render_template :index
      end

      it 'shows link to project space' do
        expect(response.body).to include orga_projects_path
      end

      it 'shows link to teams space' do
        expect(response.body).to include orga_teams_path
      end

      it 'shows link to conferences space' do
        expect(response.body).to include orga_conferences_path
      end

      it 'shows link to seasons space' do
        expect(response.body).to include orga_seasons_path
      end

      it 'shows link to exports' do
        expect(response.body).to include orga_exports_path
      end

      it 'does not show link to rating space' do
        expect(response.body).not_to include rating_path
      end
    end
  end
end
