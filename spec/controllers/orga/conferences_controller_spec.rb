require 'spec_helper'

RSpec.describe Orga::ConferencesController do
  render_views

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to be_success
        expect(response).to render_template 'index'
      end
    end

    describe 'POST create' do
      it 'creates a record' do
        expect {
          post :create, params: {conference: attributes_for(:conference)}
        }.to change { Conference.count }.by 1
        expect(response).to redirect_to [:orga, Conference.last]
      end

      it 'sets the current season' do
        post :create, params: {conference: attributes_for(:conference)}
        expect(assigns(:conference).season.name).to eql Date.today.year.to_s
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
