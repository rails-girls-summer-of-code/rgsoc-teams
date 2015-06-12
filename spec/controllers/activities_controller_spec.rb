require 'spec_helper'

describe ActivitiesController do
  render_views

  describe 'GET index' do
    let!(:mailings)     { create_list :activity, 1, :published, :mailing }
    let!(:feed_entries) { create_list :activity, 1, :published, :feed_entry }

    it 'renders the index template' do
      get :index
      expect(response).to render_template 'index'
    end

    it 'will not display mailings' do
      get :index
      expect(assigns(:activities)).to match_array feed_entries
    end
  end
end
