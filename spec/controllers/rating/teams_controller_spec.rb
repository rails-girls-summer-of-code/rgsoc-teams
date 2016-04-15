require 'spec_helper'

describe Rating::TeamsController, type: :controller do
  render_views

  describe 'GET show' do
    let(:team) { create :team, :with_applications }

    it 'requires login' do
      get :show, id: team
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :show, id: team
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user) { create :reviewer }

      before { sign_in user }

      context 'when team has no ratings yet' do
        before { get :show, id: team }

        it 'assigns @team' do
          expect(assigns :team).to eq team
        end

        it 'assigns @applications' do
          expect(assigns :applications).to be
        end

        it 'assigns new @rating' do
          expect(assigns :rating).to be_a_new Rating
        end

        it 'renders rating/teams/show' do
          expect(response).to render_template 'rating/teams/show'
        end
      end
      context 'when team already has rating' do
        let!(:rating) { create :rating, :for_team, user: user, rateable: team }

        it 'assigns existing @rating' do
          get :show, id: team
          expect(assigns :rating).to eq rating
        end
      end
    end
  end
end
