require 'rails_helper'

RSpec.describe Organizers::ExportsController, type: :controller do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders a form' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST create' do
      it 'sends CSV data as attachment' do
        filename_matcher = /attachment; filename="exporters-teams_current\.csv/
        post :create, params: { export: "Exporters::Teams#current" }
        expect(response).to have_http_status(:success)
        expect(response.headers["Content-Disposition"]).to match filename_matcher
        expect(response.headers["Content-Type"]).to eq "text/csv"
      end

      it 'should return a 404 if the exporter is not in the whitelist' do
        post :create, params: { export: "Exporters::DoesNotExist#method" }
        expect(response).to be_not_found
      end
    end
  end
end
