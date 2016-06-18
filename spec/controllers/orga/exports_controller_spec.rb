require 'spec_helper'

RSpec.describe Orga::ExportsController do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders a form' do
        get :index
        expect(response).to be_success
      end
    end

    describe 'POST create' do
      it 'sends CSV data as attachment' do
        filename_matcher = /attachment; filename="exporters-teams_current\.csv/
        post :create, { export: "Exporters::Teams#current" }
        expect(response).to be_success
        expect(response.headers["Content-Disposition"]).to match filename_matcher
        expect(response.headers["Content-Type"]).to eq "text/csv"
      end
    end
  end
end
