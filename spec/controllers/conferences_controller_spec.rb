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
    context 'unauthenticated users' do
      it 'cannot create new conference' do
        get :new
        expect(response).to redirect_to(root_url)
      end
    end

    context 'student logged in' do
      let!(:student) { FactoryGirl.create(:student) }
      before :each do
        sign_in student
      end

      it 'are allowed to visit a new conference view' do
        get :new
        expect(response).to render_template("new")
      end

      it 'are allowed to create a new conference' do
        expect{
          post :create, params: { conference: {name: 'name', country: 'country', region: 'region', location: 'location', city: 'city', season_id:'1'}}
        }.to change { Conference.count }.by(1)
        expect(response).to redirect_to(conference_path(1))
      end
    end
  end
end
