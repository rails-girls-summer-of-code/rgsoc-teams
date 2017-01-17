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
    skip
  end
end
