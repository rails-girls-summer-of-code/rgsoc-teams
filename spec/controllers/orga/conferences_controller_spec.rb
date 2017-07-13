require 'spec_helper'

RSpec.describe Orga::ConferencesController do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to be_success
        expect(response).to render_template 'index'
      end
    end

    describe 'POST import' do

      let(:file) { fixture_file_upload("spec/fixtures/files/test.csv", 'text/csv') }

      it 'posts a .csv file' do
        post :import, params: { file: file  }
        expect(response).to redirect_to (orga_conferences_path)
        expect(flash[:notice]).to match(/Import finished/)
      end

      it 'refuses other formats' do
        post :import, format: :json, params: { file: file}
        expect(response).not_to be_success
      end
    end
    
    describe 'DELETE destroy' do
      let!(:conference) { create :conference }

      it 'destroys the resource' do
        expect {
          delete :destroy, params: {id: conference}
        }.to change { Conference.count }.by(-1)
        expect(response).to redirect_to orga_conferences_path
      end
    end
  end
end
