require 'rails_helper'

RSpec.describe Organizers::SeasonsController, type: :controller do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    let(:season) { Season.create name: 2015 }

    describe 'GET new' do
      it 'renders the new template' do
        get :new
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'new'
      end
    end

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'index'
      end
    end

    describe 'GET edit' do
      it 'renders the edit template' do
        get :edit, params: { id: season.to_param }
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'edit'
      end
    end

    describe 'GET show' do
      it 'renders the show template' do
        get :show, params: { id: season.to_param }
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'show'
      end
    end

    describe 'PATCH update' do
      it 'updates and redirects' do
        patch :update, params: { id: season.to_param, season: { name: '1999' } }
        expect(response).to redirect_to organizers_seasons_path
      end

      context 'with invalid data' do
        let!(:season) { create :season }

        it 'fails updates and renders the edit template' do
          patch :update, params: { id: season.to_param, season: { name: '' } }
          expect(response).to render_template 'edit'
        end
      end
    end
  end
end
