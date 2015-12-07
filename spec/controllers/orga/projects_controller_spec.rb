require 'spec_helper'

RSpec.describe Orga::ProjectsController do
  render_views

  it_behaves_like 'redirects for non-admins'

  context 'with admin logged in' do
    include_context 'with admin logged in'

    let(:project) { Project.create name: 2015 }

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to be_success
        expect(response).to render_template 'index'
      end
    end

    shared_examples_for 'deals with proposals' do |action|

      describe "PUT #{action}" do
        let(:project) { create :project }

        context 'with an accepted record' do
          let!(:project) { create :project, :"#{action}ed" }
          it 'complains and redirects to show' do
            put action, id: project.to_param
            expect(response).to redirect_to [:orga, :projects]
            expect(flash[:alert]).to be_present
          end
        end

        it "#{action}s and redirect to show" do
          expect {
            put action, id: project.to_param
          }.to change { project.reload.aasm_state }.to "#{action}ed"
          expect(response).to redirect_to [:orga, :projects]
          expect(flash[:notice]).to be_present
        end
      end
    end

    it_behaves_like 'deals with proposals', :accept
    it_behaves_like 'deals with proposals', :reject

  end

end
