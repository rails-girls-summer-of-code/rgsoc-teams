require 'spec_helper'

describe Rating::ApplicationsController do
  render_views

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
  end

  describe 'GET index' do
    context 'as an authenticated user' do
      let(:user) { create :user }
      before { sign_in user }

      context 'as a non-reviewer' do
        it 'disallows access to the list of applications' do
          get :index
          expect(response).to redirect_to root_path
        end
      end
      context 'as a reviewer' do
        let(:user) { create(:reviewer_role).user }
        let(:application_draft) { create :application_draft, :appliable }
        let!(:application) do
          CreatesApplicationFromDraft.new(application_draft).tap { |c| c.save }.application
        end

        before { get :index }

        it 'initializes @applications as a new Application::Table' do
          expect(assigns :applications).to be_a Application::Table
        end

        it 'lists all available applications' do
          expect(response).to be_success
        end
      end
    end
  end
  describe 'GET show' do
    let(:application) { create :application }

    it 'requires login' do
      get :show, id: application
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :show, id: application
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end
    context 'when reviewer' do
      let(:user) { create :reviewer }
      before { sign_in user }

      context 'when application not yet rated by user' do
        before { get :show, id: application }

        it 'assigns @application' do
          expect(assigns :application).to eq application
        end

        it 'assigns new @rating from user' do
          expect(assigns :rating).to be_a_new Rating
          expect(assigns :rating).to have_attributes(user: user, rateable: application)
        end

        it 'renders rating/applications/show' do
          expect(response).to render_template 'rating/applications/show'
        end
      end
      context 'when application already rated by user' do
        let!(:rating) { create :rating, :for_application, user: user, rateable: application }

        it 'assigns existing @rating' do
          get :show, id: application
          expect(assigns :rating).to eq rating
        end
      end
    end
  end
  describe 'GET edit' do
    let(:application) { create :application }

    it 'requires login' do
      get :edit, id: application
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :edit, id: application
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end
    context 'when reviewer' do
      let(:user) { create :reviewer }
      before do
        sign_in user
        get :edit, id: application
      end

      it 'assigns @application' do
        expect(assigns :application).to eq application
      end

      it 'renders rating/applications/edit' do
        expect(response).to render_template 'rating/applications/edit'
      end
    end
  end
  describe 'PUT update' do
    let(:application) { create :application }

    it 'requires login' do
      get :edit, id: application
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :edit, id: application
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end
    context 'when reviewer' do
      let(:user) { create :reviewer }
      before { sign_in user }

      context 'with valid params' do
        let(:params) { {id: application, application: {mentor_pick: 1}} }

        it 'assigns @application' do
          put :update, params
          expect(assigns :application).to eq application
        end

        it 'changes application record' do
          expect{
            put :update, params
            application.reload
          }.to change{application.mentor_pick}.to true
        end

        it 'redirect to index' do
          put :update, params
          expect(response).to redirect_to [:rating, Application]
        end
      end
    end
  end
end
