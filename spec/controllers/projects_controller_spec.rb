require 'spec_helper'

RSpec.describe ProjectsController do
  render_views

  describe 'GET index' do
    let!(:proposed) { create :project, name: 'proposed project' }
    let!(:accepted) { create :project, :accepted, name: 'accepted project' }
    let!(:rejected) { create :project, :rejected, name: 'rejected project' }

    it 'displays all projects by default' do
      get :index
      expect(response).to be_success
      expect(response.body).to include 'proposed project'
      expect(response.body).to include 'accepted project'
      expect(response.body).to include 'rejected project'
    end
  end

  describe 'GET new' do
    it 'requires a login' do
      get :new
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'with user logged in' do
      include_context 'with user logged in'

      it 'returns success' do
        get :new
        expect(response).to be_success
      end
    end
  end
end
