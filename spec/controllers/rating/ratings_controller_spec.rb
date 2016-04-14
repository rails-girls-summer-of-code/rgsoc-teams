require 'spec_helper'

describe Rating::RatingsController, type: :controller do
  render_views

  describe 'POST create' do
    it 'requires login' do
      post :create
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      post :create
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user) { create :reviewer }
      before { sign_in user }

      context 'when rating an application' do
        let(:team) { create :team }
        let!(:application) { create :application, team: team }
        let(:params) { {rating: {rateable_id: application.id, rateable_type: 'Application', data: {diversity: 5}}} }

        context 'when team not already rated by user' do
          it 'creates new rating record for team' do
            expect{
              post :create, params
            }.to change{Rating.count}.by 1
          end

          it 'redirect_to rating/application' do
            post :create, params
            expect(response).to redirect_to [:rating, application]
          end
        end
        context 'when team already rated by user' do
          let(:rating) { create :rating, :for_team, user: user, rateable: team }

          it 'updates existing rating record' do
            expect{
              post :create, params
              rating.reload
            }.to change{rating.data}
          end
        end
      end
    end
  end
  describe 'PUT update' do
    let(:user) { create :reviewer }
    let(:team) { create :team }
    let!(:application) { create :application, team: team }

    context 'when reviewer' do
      before { sign_in user }

      context 'when user not author of rating' do
        let!(:rating) { create :rating, :for_team, user: create(:user), rateable: team }
        let(:params) { {id: rating, rating: { data: { planning: 0 }}} }

        it 'raises RecordNotFound exception' do
          expect{
            put :update, params
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
      context 'when user author of rating' do
        let!(:rating) { create :rating, :for_team, user: user, rateable: team }
        let(:params) { {id: rating, rating: { data: { planning: 0 }}} }

        it 'updates rating' do
          expect{
            put :update, params
            rating.reload
          }.to change{rating.data}
        end

        it 'redirect_to rating/application' do
          put :update, params
          expect(response).to redirect_to [:rating, application]
        end
      end
    end
  end
end
