require 'spec_helper'

RSpec.describe Orga::ConferencesController do
  render_views

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'POST create' do
      it 'creates a record' do
        expect {
          post :create, conference: attributes_for(:conference)
        }.to change { Conference.count }.by 1
        expect(response).to redirect_to Conference.last
      end

      it 'sets the current season' do
        post :create, conference: attributes_for(:conference)
        expect(assigns(:conference).season.name).to eql Date.today.year.to_s
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