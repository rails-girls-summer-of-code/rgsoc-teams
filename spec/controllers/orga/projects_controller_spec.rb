require 'spec_helper'

RSpec.describe Orga::ProjectsController do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    let(:project) { Project.create name: 2015 }

    describe 'GET new' do
      it 'renders the new template' do
        skip "waiting for CRUD templates in public namespace"
        get :new
        expect(response).to be_success
        expect(response).to render_template 'new'
      end
    end

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to be_success
        expect(response).to render_template 'index'
      end
    end

    describe 'GET edit' do
      it 'renders the edit template' do
        skip "waiting for CRUD templates in public namespace"
        get :edit, id: project.to_param
        expect(response).to be_success
        expect(response).to render_template 'edit'
      end
    end

    describe 'GET show' do
      it 'renders the show template' do
        skip "waiting for CRUD templates in public namespace"
        get :show, id: project.to_param
        expect(response).to be_success
        expect(response).to render_template 'show'
      end
    end

    describe 'PATCH update' do
      it 'updates and redirects' do
        skip "waiting for CRUD templates in public namespace"
        patch :update, id: project.to_param, project: { name: '2525' }
        expect(response).to redirect_to orga_projects_path
      end

      context 'with invalid data' do
        before do
          project
          allow_any_instance_of(Project).to receive(:valid?).and_return(false)
        end

        it 'fails updates and renders the edit template' do
          skip "waiting for CRUD templates in public namespace"
          patch :update, id: project.to_param, project: { name: '' }
          expect(response).to render_template 'edit'
        end
      end
    end

    shared_examples_for 'deals with proposals' do |action|

      describe "PUT #{action}" do
        let(:project) { create :project }

        context 'with an accepted record' do
          let!(:project) { create :project, :"#{action}ed" }
          it 'complains and redirects to show' do
            put action, id: project.to_param
            expect(response).to redirect_to [:orga, project]
            expect(flash[:alert]).to be_present
          end
        end

        it "#{action}s and redirect to show" do
          expect {
            put action, id: project.to_param
          }.to change { project.reload.aasm_state }.to "#{action}ed"
          expect(response).to redirect_to [:orga, project]
          expect(flash[:notice]).to be_present
        end
      end
    end

    it_behaves_like 'deals with proposals', :accept
    it_behaves_like 'deals with proposals', :reject

  end
end
