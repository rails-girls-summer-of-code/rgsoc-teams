require 'spec_helper'

describe ActivitiesController do
  render_views

  describe 'GET index' do
    let!(:mailings)       { create_list :activity, 1, :published, :mailing }
    let!(:feed_entries)   { create_list :activity, 1, :published, :feed_entry }
    let!(:status_updates) { create_list :status_update, 1, :published }

    it 'renders the index template' do
      get :index
      expect(response).to render_template 'index'
    end

    it 'renders the json feed' do
      get :index, format: :json
      expect(response).to be_success
    end

    it 'renders the atom feed' do
      get :index, format: :atom
      expect(response).to render_template 'index'
    end

    it 'will not display mailings' do
      get :index
      expect(assigns(:activities)).to match_array feed_entries + status_updates
    end
  end
end
