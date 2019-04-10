require 'rails_helper'

RSpec.describe ConferencesController, type: :controller do
  render_views

  describe 'GET index' do
    let(:last_season)            { Season.create name: Date.today.year - 1 }
    let!(:current_conference)    { create :conference, :in_current_season }
    let!(:last_years_conference) { create :conference, season: last_season }

    it 'displays all of this season\'s conferences' do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:conferences)).to match_array [current_conference]
    end
  end

  describe 'show details' do
    let(:conference) { create :conference, :in_current_season }
    it 'should show the requested conference' do
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
      let!(:student) { create(:student) }

      before do
        sign_in student
      end

      it 'are allowed to visit a new conference view' do
        get :new
        expect(response).to render_template("new")
      end
    end
  end

  describe 'POST create via XHR' do
    context 'with an unauthenticated user' do
      let(:conference_attrs) { attributes_for :conference }

      it 'cannot create a new conference' do
        expect {
          post :create,
          params: { conference: conference_attrs },
          xhr: true
        }.not_to change { Conference.count }
      end

      it 'should return a 401 response status' do
        post :create, params: { conference: conference_attrs }, xhr: true
        expect(response).to have_http_status(401)
      end
    end

    context 'with user logged in' do
      let(:student) { create(:student) }
      let(:conference_attrs) { attributes_for :conference }

      before do
        sign_in student
      end

      context 'and incorrect params' do
        it 'should not create a new conference' do
          expect {
            post :create,
            params: { conference: { name: "name" } },
            xhr: true
          }.not_to change { Conference.count }
        end
      end

      it 'should create a new conference' do
        expect {
          post :create,
          params: { conference: conference_attrs },
          xhr: true
        }.to change { Conference.count }.by(1)
      end
    end
  end
end
