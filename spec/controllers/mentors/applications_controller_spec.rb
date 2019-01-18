require 'rails_helper'

RSpec.describe Mentors::ApplicationsController, type: :controller do
  render_views

  let(:user) { create(:user) }

  # Make sure the current season did not end yet
  before do
    allow(Season).to receive(:transition?) { false }
  end

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
        let!(:application) { create(:application, :in_current_season, :for_project, project1: project) }
        let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }

        it 'renders an index view with applications for projects submitted by the mentor' do
          get :index

          expect(assigns :applications).not_to be_empty
          expect(assigns :applications).to all(be_a(Mentor::Application))
          expect(response).to render_template :index
        end

        it 'shows the comments' do
          Mentor::Comment.create! commentable_id: application.id, user: user, text: "Tis a nice application indeed"
          get :index

          expect(response.body).to match "Tis a nice application indeed"
        end

        context 'when the user is not the submitter but in the list of maintainers' do
          let!(:project) { create(:project, :in_current_season, :accepted, name: 'Hello World Project') }
          let!(:maintenance) do
            create(:maintainership, project: project, user: user)
          end

          it 'renders an index view with applications for their maintained projects' do
            get :index
            expect(response.body).to match 'Hello World Project'
          end
        end
      end

      context 'without projects for this season' do
        let!(:project) { create(:project, :accepted, submitter: user) }

        it 'renders an empty index view' do
          get :index
          expect(assigns :applications).to eq []
          expect(response).to render_template :index
        end
      end

      context 'without applications for the projects' do
        let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }

        it 'renders an empty index view' do
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
      let!(:project)   { create(:project, :in_current_season, :accepted, submitter: user) }

      before { sign_in user }

      context 'for an application that they are a mentor of' do
        let(:application)   { create(:application, :in_current_season, :for_project, project1: project) }
        let(:m_application) { Mentor::Application.new(id: application.id, choice: 1) }

        subject { put :signoff, params: { id: application.id } }

        it 'sets the sign-off timestamp for the project choice' do
          expect { subject }
            .to change { application.reload.data.signed_off_at_project1 }
            .from nil
        end

        it 'persists the mentor id who signed-off' do
          expect { subject }
            .to change { application.reload.data.signed_off_by_project1 }
            .to(user.id.to_s)
        end

        it 'redirects back to index' do
          subject
          expect(response).to redirect_to mentors_applications_path
          expect(flash[:notice]).to be_present
        end

        context 'undo\'ing the sign-off' do
          before { m_application.sign_off! as: user }

          it 'resets the sign-off timestamp' do
            expect { subject }
              .to change { application.reload.data.signed_off_at_project1 }
              .to nil
          end

          it 'resets the mentor who signed-off' do
            expect { subject }
              .to change { application.reload.data.signed_off_by_project1 }
              .to nil
          end
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
        let(:application)   { create(:application, :in_current_season, :for_project, project1: project) }
        let(:m_application) { Mentor::Application.new(id: application.id, choice: 1) }

        subject { put :fav, params: { id: application.id } }

        it 'sets the mentor_fav flag' do
          expect { subject }
            .to change { application.reload.data.mentor_fav_project1 }
            .to 'true'
        end

        it 'redirects back to index' do
          subject
          expect(response).to redirect_to mentors_applications_path
          expect(flash[:notice]).to be_present
        end

        it 'revokes a previous fav' do
          m_application.mentor_fav!
          expect { subject }
            .to change { application.reload.application_data['mentor_fav_project1'] }
            .to nil
          expect(response).to redirect_to mentors_applications_path
          expect(flash[:notice]).to be_present
        end
      end

      context 'when not maintaining the project' do
        it 'returns a 404' do
          other_project = create(:project, :in_current_season, :accepted, submitter: build(:user))
          application   = create(:application, :in_current_season, :for_project, project1: other_project)

          expect { put :fav, params: { id: application.id } }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
