require 'spec_helper'

describe ActivitiesController do
  render_views

  describe 'GET index' do
    it 'renders the index template' do
      create :student_role, team: create(:team, name: nil)
      get :index
      expect(response).to render_template 'index'
    end
  end
end
