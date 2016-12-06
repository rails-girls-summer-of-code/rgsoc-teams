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

  describe 'show details' do
    let(:conference) { create :conference, :in_current_season }
    it 'should show the requested network' do
      get :show, params: { id: conference.id }
      expect(assigns(:conference)).to eq(conference)
    end
  end

  describe 'new' do
    it 'redirects unauthorized users' do
      get :new
      expect(response).to redirect_to orga_conferences_path
      expect(Conference).to_not receive(:create)
    end
  end
end
