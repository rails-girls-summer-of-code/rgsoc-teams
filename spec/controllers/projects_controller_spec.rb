require 'spec_helper'

RSpec.describe ProjectsController do
  render_views

  let(:project) { FactoryGirl.create(:project) }

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

      it "assigns a new project as @project" do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
      end
    end
  end

  describe 'POST create' do
    context 'with user logged in' do
      include_context 'with user logged in'
      let(:attributes) { attributes_for :project }


      it 'creates a project and redirects to list' do
        expect { post :create, project: attributes }.to \
          change { Project.count }.by 1
        expect(flash[:notice]).not_to be_nil
        expect(response).to redirect_to(projects_path)
      end

      it 'fails to create a project from invalid parameters' do
        expect { post :create, project: { name: '' } }.not_to \
          change { Project.count }
        expect(response.body).to include 'prohibited this project from being saved'
        expect(response).to render_template 'new'
      end
    end

  end

end
