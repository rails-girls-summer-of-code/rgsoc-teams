require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  render_views

  let(:project) { create(:project) }

  describe 'GET index' do
    context 'between seasons' do
      before { Timecop.travel Date.parse('2015-12-15') }

      let!(:proposed) { create(:project, season: Season.succ, name: 'proposed project') }
      let!(:accepted) { create(:project, :accepted, season: Season.succ, name: 'accepted project') }
      let!(:rejected) { create(:project, :rejected, season: Season.succ, name: 'rejected project') }

      it 'hides rejected projects' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response.body).to include 'proposed project'
        expect(response.body).to include 'accepted project'
        expect(response.body).not_to include 'rejected project'
      end
    end

    context 'during active Season' do
      before { Timecop.travel Season.current.starts_at }

      let!(:proposed) { create(:project, season: Season.succ, name: 'proposed project') }
      let!(:selected) { create(:project, :accepted, :in_current_season, name: "selected by a team") }
      let!(:no_team)  { create(:project, :accepted, :in_current_season, name: "project without team") }
      let!(:team)     { create(:team, :in_current_season, project: selected) }

      it 'shows selected projects only' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response.body).to include "selected by a team"
        expect(response.body).not_to include 'project without team'
        expect(response.body).not_to include 'proposed project'
      end
    end

    context 'with a season filter' do
      let!(:season2017)   { Season.find_or_create_by(name: '2017') }
      let!(:proposed)     { create(:project, :in_current_season, name: 'proposed project') }
      let!(:selected2017) { create(:project, :accepted, season: season2017, name: "selected by a team 2017") }
      let!(:selected)     { create(:project, :accepted, :in_current_season, name: "selected by a team (current)") }
      let!(:no_team)      { create(:project, :accepted, season: season2017, name: "project without team 2017") }
      let!(:team)         { create(:team, season: season2017, project: selected2017) }

      it 'shows selected projects in past season only' do
        get :index, params: { filter: '2017' }
        expect(response).to have_http_status(:success)
        expect(response.body).to include "selected by a team 2017"
        expect(response.body).not_to include "selected by a team (current)"
        expect(response.body).not_to include 'project without team 2017'
        expect(response.body).not_to include 'proposed project 2017'
      end
    end
  end

  describe 'GET new' do
    context 'during project submission time' do
      before do
        allow(Season).to receive(:projects_proposable?) { true }
      end

      it 'requires a login' do
        expect { get :new }.to \
          change { session[:previous_url_login_required] }
        expect(response).to have_http_status(:success)
        expect(response.body).to match user_github_omniauth_authorize_path
      end
    end

    context 'with user logged in' do
      include_context 'with user logged in'

      context 'during project submission time' do
        before do
          allow(Season).to receive(:projects_proposable?) { true }
        end

        it 'returns success' do
          get :new
          expect(response).to have_http_status(:success)
        end

        it "assigns a new project as @project" do
          get :new
          expect(assigns(:project)).to be_a_new(Project)
        end
      end
    end
  end

  describe 'GET show' do
    it 'returns the project page' do
      get :show, params: { id: project.to_param }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH update' do
    let!(:project) { create(:project, submitter: current_user) }
    context 'with user logged in' do
      include_context 'with user logged in'
      let(:current_user) { create(:user) }

      it 'creates a project and redirects to list' do
        patch :update, params: { id: project.to_param, project: { name: "This is an updated name!" } }
        expect(flash[:notice]).not_to be_nil
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe 'POST preview' do
    it 'renders partial preview' do
      post :preview, xhr: true, params: { project: project.attributes }
      expect(response).to render_template "_preview"
    end
  end

  describe 'POST create' do
    context 'with user logged in' do
      include_context 'with user logged in'
      let(:valid_attributes) { attributes_for :project }

      def mailer_jobs
        enqueued_jobs.select do |job|
          job[:job] == ActionMailer::DeliveryJob &&
            job[:args][0] == 'ProjectMailer' && job[:args][1] == 'proposal'
        end
      end

      context 'during project submission time' do
        before do
          allow(Season).to receive(:projects_proposable?) { true }
        end

        it 'creates a project and redirects to thank you message' do
          expect { post :create, params: { project: valid_attributes } }.to \
            change { Project.count }.by 1
          expect(response).to redirect_to(receipt_project_path(assigns(:project)))
        end

        it 'sends an email to organizers' do
          expect { post :create, params: { project: valid_attributes } }.to \
            change { mailer_jobs.size }.by 1
        end

        it 'fails to create a project from invalid parameters' do
          expect { post :create, params: { project: { name: '' } } }.not_to \
            change { Project.count }
          expect(response.body).to include 'prohibited this project from being saved'
          expect(response).to render_template 'new'
        end

        context 'with season' do
          subject { Project.last }

          context 'in December' do
            before do
              Timecop.travel Date.parse('2015-12-06')
              post :create, params: { project: valid_attributes }
            end

            it { expect(subject.season.year).to eql '2016' }
          end

          context 'in January' do
            before do
              Timecop.travel Date.parse('2016-01-10')
              post :create, params: { project: valid_attributes }
            end

            it { expect(subject.season.year).to eql '2016' }
          end
        end
      end

      context 'after project proposals have been closed' do
        before { Timecop.travel Date.parse('2016-03-01') }

        it 'will not create a project' do
          expect { post :create, params: { project: valid_attributes } }.not_to \
            change { Project.count }
          expect(response).to redirect_to root_path
          expect(flash[:alert]).to be_present
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'with user logged in' do
      include_context 'with user logged in'
      let(:current_user) { create(:user) }
      let!(:project) { create(:project, submitter: current_user) }

      it 'deletes the project' do
        expect { delete :destroy, params: { id: project.to_param } }.to \
          change { Project.count }.by(-1)
        expect(flash[:notice]).not_to be_nil
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end
