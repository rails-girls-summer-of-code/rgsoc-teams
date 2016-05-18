require 'spec_helper'

RSpec.describe ConferencesController do
  render_views

  describe 'GET index' do
    before { get :index }

    specify do
      expect(response.response_code).to eq 200
      expect(response).to render_template('conferences/index')
    end
  end

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'POST create' do
      it 'creates a record' do
        expect {
          post :create, conference: attributes_for(:conference)
        }.to change { Conference.count }.by 1
        expect(response).to redirect_to Conference.last
      end
    end

    describe 'DELETE destroy' do
      let!(:conference) { create :conference }

      it 'destroys the resource' do
        expect {
          delete :destroy, id: conference
        }.to change { Conference.count }.by(-1)
        expect(response).to redirect_to conferences_path
      end

    end
  end

end
