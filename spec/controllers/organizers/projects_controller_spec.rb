require 'rails_helper'

RSpec.describe Organizers::ProjectsController, type: :controller do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    let(:project) { create :project }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'index'
      end
    end

    describe 'PUT start_review' do
      it 'start review before accept or reject a project' do
        expect { put :start_review, params: { id: project.to_param } }.
          to change { project.reload.aasm_state }.to "pending"
        expect(response).to redirect_to [:organizers, :projects]
        expect(flash[:notice]).to be_present
      end
    end

    shared_examples_for 'deals with pending' do |action, state|
      let(:project) { create :project, :pending }

      describe "PUT #{action}" do
        context 'with an pending record' do
          it 'complains and redirects to show' do
            put action, params: { id: project.to_param }
            expect(response).to redirect_to [:organizers, :projects]
            expect(flash[:notice]).to be_present
          end
        end

        it "#{action}s and redirect to show" do
          expect {
            put action, params: { id: project.to_param }
          }.to change { project.reload.aasm_state }.to state.to_s
          expect(response).to redirect_to [:organizers, :projects]
          expect(flash[:notice]).to be_present
        end
      end
    end

    it_behaves_like 'deals with pending', :accept, :accepted
    it_behaves_like 'deals with pending', :reject, :rejected

    describe 'PUT lock' do
      it 'toggles the comments_locked boolean' do
        expect { put :lock, params: { id: project.to_param } }.
          to change { project.reload.comments_locked? }.to true
        expect(response).to redirect_to [:organizers, :projects]
      end
    end

    describe 'PUT unlock' do
      let!(:project) { create :project, comments_locked: true }

      it 'toggles the comments_unlocked boolean' do
        expect { put :unlock, params: { id: project.to_param } }.
          to change { project.reload.comments_locked? }.to false
        expect(response).to redirect_to [:organizers, :projects]
      end
    end
  end
end
