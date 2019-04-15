require 'rails_helper'

RSpec.describe ActivitiesController, type: :controller do
  render_views

  describe 'GET index' do
    let!(:mailings)       { create_list :activity, 1, :published, :mailing }
    let!(:feed_entries)   { create_list :activity, 1, :published, :feed_entry }
    let!(:status_updates) { create_list :status_update, 1, :published }

    it 'renders the index template' do
      get :index
      expect(response).to render_template 'index'
    end

    context 'as feed' do
      it 'renders json' do
        get :index, format: :json
        expect(response).to have_http_status(:success)
      end

      it 'renders atom' do
        get :index, format: :atom
        expect(response).to have_http_status(:success)
      end

      it 'will not display mailings' do
        get :index, format: %w(json atom).sample
        expect(assigns(:activities)).to match_array feed_entries + status_updates
      end
    end

    it 'will not display mailings' do
      get :index
      expect(assigns(:activities)).to match_array feed_entries + status_updates
    end
  end
end
