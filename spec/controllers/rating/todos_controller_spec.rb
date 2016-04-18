require 'spec_helper'

describe Rating::TodosController, type: :controller do
  render_views

  describe 'GET index' do
    it 'requires login' do
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user) { create :reviewer }
      let(:current_season) { Season.create name: Date.today.year }
      let(:last_season) { Season.create name: Date.today.year-1 }
      let!(:applications_from_current_season) { create_list :application, 3, season: current_season }
      let!(:application_from_last_season) { create :application, season: last_season }

      before do
        sign_in user
        get :index
      end

      it 'assigns @applications with applications from current season' do
        expect(assigns :applications).to match_array applications_from_current_season
      end

      it 'renders :index' do
        expect(response).to render_template 'rating/todos/index'
      end
    end
  end
end
