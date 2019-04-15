require 'rails_helper'

RSpec.describe Organizers::ConferencesController, type: :controller do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'index'
      end
    end

    describe 'POST import' do
      let(:file) { fixture_file_upload("spec/fixtures/files/test.csv", 'text/csv') }

      it 'posts a .csv file' do
        post :import, params: { file: file  }
        expect(response).to redirect_to (organizers_conferences_path)
        expect(flash[:notice]).to match(/Import finished/)
      end

      it 'refuses other formats' do
        post :import, format: :json, params: { file: file }
        expect(response).not_to have_http_status(:success)
      end

      it 'catches error when file is omitted' do
        post :import
        expect(response).to redirect_to organizers_conferences_path
        expect(flash[:alert]).to be_present
      end
    end

    describe 'DELETE destroy' do
      let!(:conference) { create :conference }

      it 'destroys the resource' do
        expect {
          delete :destroy, params: { id: conference }
        }.to change { Conference.count }.by(-1)
        expect(response).to redirect_to organizers_conferences_path
      end
    end

    describe 'POST create' do
      let(:conference_attrs) { attributes_for :conference }

      context 'with incorrect params' do
        it 'should not create a new conference' do
          expect {
            post :create,
            params: { conference: { name: "name" } }
          }.not_to change { Conference.count }
        end
      end

      it 'should create a new conference' do
        expect {
          post :create,
          params: { conference: conference_attrs }
        }.to change { Conference.count }.by(1)
      end
    end
  end
end
