require 'spec_helper'

RSpec.describe Mentor::ApplicationsController do
  render_views

  let(:user) { create(:user) }

  describe 'GET index' do
    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      it 'redirects to the landing page' do
        sign_in user
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as a project_maintainer' do
      before { sign_in user }

      context 'with appliations for this season' do
        it 'renders and index view with applications for projects submitted by the mentor' do
          project = create(:project, :in_current_season, :accepted, submitter: user)
          create(:application, :in_current_season, :for_project, project1: project)

          get :index

          expect(assigns :applications).not_to be_empty
          expect(assigns :applications).to all( be_a(Mentor::Application) )
          expect(response).to render_template :index
        end
      end

      context 'without projects for this season' do
        it 'renders an empty index view' do
          project = create(:project, :accepted, submitter: user)

          get :index
          expect(assigns :applications).to eq []
          expect(response).to render_template :index
        end
      end

      context 'without applications for the projects' do
        it 'renders an empty index view' do
          project = create(:project, :in_current_season, :accepted, submitter: user)

          get :index
          expect(assigns :applications).to eq []
          expect(response).to render_template :index
        end
      end
    end
  end

  describe 'GET show' do
    let(:user) { create(:user) }

    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      it 'redirects to the landing page' do
        sign_in user
        get :show, params: { id: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a project_maintainer of this season' do
      let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }

      before { sign_in user }

      context 'when 1st choice application for project' do
        it 'renders the show view' do
          application = create(:application, :in_current_season, :for_project, project1: project)

          get :show, params: { id: application.id }

          expect(assigns :application).to be_a Mentor::Application
          expect(response).to render_template :show
        end
      end

      context 'when 2nd choice application for project' do
        it 'renders the show view' do
          application = create(:application, :in_current_season, :for_project,
            project1: build(:project), project2: project)

          get :show, params: { id: application.id }

          expect(assigns :application).to be_a Mentor::Application
          expect(response).to render_template :show
        end
      end

      context 'when not maintaining the project' do
        it 'returns a 404' do
          other_project = create(:project, :in_current_season, :accepted)
          application   = create(:application, :in_current_season, :for_project, project1: other_project)
          params        = { id: application.id, choice: 1 }

          expect { get :show, params: params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PUT signoff' do
    context 'as a project_maintainer of this season' do
      let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }

      before { sign_in user }

      context 'for an application that they are a mentor of' do
        let(:application) { create(:application, :in_current_season, :for_project, project1: project) }

        it 'sets the sign-off timestamp' do
          expect { put :signoff, params: { id: application.id } }
            .to change { application.reload.signed_off_at }.from nil
        end

        it 'set persists the mentor who signed-off' do
          expect { put :signoff, params: { id: application.id } }
            .to change { application.reload.signatory }.to user
        end

        it 'redirects back to index' do
          put :signoff, params: { id: application.id }
          expect(response).to redirect_to mentor_applications_path
          expect(flash[:notice]).to be_present
        end
      end

      context 'when not maintaining the project' do
        it 'returns a 404' do
          other_project = create(:project, :in_current_season, :accepted)
          application   = create(:application, :in_current_season, :for_project, project1: other_project)

          expect { put :signoff, params: { id: application.id } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PUT fav' do
    context 'as a project_maintainer of this season' do
      let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }

      before { sign_in user }

      context 'for an application that they are a mentor of' do
        let(:application) { create(:application, :in_current_season, :for_project, project1: project) }

        it 'sets the mentor_fav flag' do
          expect { put :fav, params: { id: application.id } }
            .to change { application.reload.mentor_fav }.to true
        end

        it 'redirects back to index' do
          put :fav, params: { id: application.id }
          expect(response).to redirect_to mentor_applications_path
          expect(flash[:notice]).to be_present
        end
      end

      context 'when not maintaining the project' do
        it 'returns a 404' do
          other_project = create(:project, :in_current_season, :accepted)
          application   = create(:application, :in_current_season, :for_project, project1: other_project)

          expect { put :fav, params: { id: application.id } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

  end
end
