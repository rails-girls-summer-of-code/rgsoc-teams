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
      it 'does all this cool things' do
        self.class.respond_to?(:fixture_path)
        # but how do I test them? >> under investigation
      end
      
      # let(:file) { fixture_file_upload("spec/fixtures/files/test.csv") }
      #
      # it 'posts a .csv file' do
      #   post :import, params: { file: file  }
      # end
      
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
