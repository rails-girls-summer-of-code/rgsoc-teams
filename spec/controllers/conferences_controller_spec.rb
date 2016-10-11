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
end
