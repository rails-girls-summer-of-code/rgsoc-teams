require 'spec_helper'

RSpec.describe ConferencesController do
  render_views

  describe 'GET index' do
    let(:last_season)            { Season.create name: Date.today.year-1 }
    let!(:current_conference)    { create :conference, :in_current_season }
    let!(:last_years_conference) { create :conference, season: last_season }

    it 'displays all of this season\'s conferences' do
      get :index
      expect(response).to be_success
      expect(assigns(:conferences)).to match_array [current_conference]
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
