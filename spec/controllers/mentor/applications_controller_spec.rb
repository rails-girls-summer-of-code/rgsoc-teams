require 'spec_helper'

describe Mentor::ApplicationsController do
  render_views

  describe 'GET index' do
    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      it 'redirects to the landing page' do
        sign_in create(:developer)
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as a mentor' do
      let(:mentor)   { create(:mentor) }

      before { sign_in mentor }

      context 'with appliations for this season' do
        it 'renders and index view with applications for projects submitted by the mentor' do
          project = create(:project, submitter: mentor)
          create(:application, :in_current_season, :for_project, project1: project)

          get :index

          expect(assigns :applications).not_to be_empty
          expect(assigns :applications).to all( be_a(Mentor::Application) )
          expect(response).to render_template :index
        end
      end

      context 'without projects for this season' do
        it 'renders an empty index view' do
          get :index
          expect(assigns :applications).to eq []
          expect(response).to render_template :index
        end
      end

      context 'without applications for the projects' do
        it 'renders an empty index view' do
          project = create(:project, submitter: mentor)

          get :index
          expect(assigns :applications).to eq []
          expect(response).to render_template :index
        end
      end
    end
  end

  describe 'GET show' do
    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        get :show, params: { id: 1, choice: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      it 'redirects to the landing page' do
        sign_in create(:developer)
        get :show, params: { id: 1, choice: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a mentor' do
      let!(:mentor)  { create(:mentor) }
      let!(:project) { create(:project, submitter: mentor) }

      before { sign_in mentor }

      context 'when 1st choice application for project' do
        it 'renders the show view' do
          application = create(:application, :in_current_season, :for_project, project1: project)

          get :show, params: { id: application.id, choice: 1 }

          expect(assigns :application).to be_a Mentor::Application
          expect(response).to render_template :show
        end
      end

      context 'when wrong choice scope' do
        it 'returns a 404' do
          application = create(:application, :in_current_season, :for_project, project1: project)
          params      = { id: application.id, choice: 2 }

          expect { get :show, params: params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when not maintaining the project' do
        it 'returns a 404' do
          other_project = create(:project)
          application   = create(:application, :in_current_season, :for_project, project1: other_project)
          params        = { id: application.id, choice: 1 }

          expect { get :show, params: params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
