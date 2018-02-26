require 'rails_helper'

RSpec.describe ApplicationDraftsController, type: :controller do
  render_views

  let(:team) { create :team, :in_current_season }

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
    allow_any_instance_of(Team).to receive(:coaches_confirmed?).and_return(true)
  end

  context 'as an anonymous user' do
    describe 'GET new' do
      it 'renders the "sign_in" template' do
        get :new
        expect(response).to render_template 'sign_in'
      end
    end
  end

  context 'as a not confirmed user' do
    describe 'GET new' do
      let(:user) { create(:user, confirmed_at: nil) }

      before do
        allow(controller).to receive_messages(signed_in?: true)
        allow(controller).to receive_messages(current_user: user)
      end

      it 'renders the "sign_in" template' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'as an authenticated user' do
    let(:user) { create(:user) }

    shared_examples_for 'application period is over' do
      it 'new renders applications_end template when over' do
        Timecop.travel(Season.current.applications_close_at + 2.days) do
          text = "Applications for RGSoC #{Season.current.year} are closed."
          subject
          expect(response.body).to match text
        end
      end
    end

    before do
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    describe 'GET index' do
      let!(:student_role) { create :student_role, user: user, team: team }
      let!(:drafts) { create_list(:application_draft, 1, team: team) }

      it "redirects to the existing application draft's edit action" do
        get :index
        expect(assigns(:application_drafts)).to match_array(drafts)
        expect(response).to redirect_to edit_application_draft_path(drafts.first)
      end
    end

    describe 'GET new' do
      it_behaves_like 'application period is over' do
        subject { get :new }
      end

      it 'redirects if not part of a students team' do
        get :new
        expect(response).to redirect_to new_team_path
        expect(flash[:alert]).to be_present
      end

      it 'redirects for a single team member' do
        create :student_role, user: user
        get :new
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end

      it 'redirects for a team from last season' do
        create :student_role, user: user, team: create(:team, :last_season)
        get :new
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end

      it 'renders the "new" template for a tean with two students' do
        other_role = create :student_role
        create :student_role, user: user, team: other_role.team
        get :new
        expect(response).to render_template 'new'
      end

      it 'redirects to the index action if there an application draft already exists' do
        create :student_role, user: user, team: team
        team.application_drafts.create

        get :new
        expect(response).to redirect_to application_drafts_path
        expect(flash[:alert]).to be_present
      end
    end

    describe 'GET edit' do
      let(:draft) { create :application_draft }

      it 'redirects if not part of a team' do
        get :edit, params: { id: draft.to_param }
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end

      it 'will not find somebody else\'s draft' do
        create :student_role, user: user
        expect {
          get :edit, params: { id: draft.to_param }
        }.to raise_error ActiveRecord::RecordNotFound
      end

      shared_examples_for 'reading the application draft form as' do |role|
        before { create "#{role}_role", user: user, team: draft.team }

        context "as a #{role} of the team" do
          it 'renders the new template' do
            get :edit, params: { id: draft.to_param }
            expect(response).to redirect_to root_path
          end
        end
      end

      it_behaves_like 'reading the application draft form as', :coach
      it_behaves_like 'reading the application draft form as', :mentor
    end

    describe 'POST create' do
      it 'creates a draft and redirects to edit' do
        create :student_role, user: user
        expect { post :create, { params: { application_draft: { misc_info: 'Foo!' } } } }.to \
          change { ApplicationDraft.count }.by 1
        expect(flash[:notice]).not_to be_nil
        expect(response).to redirect_to [:edit, assigns[:application_draft]]
      end

      it_behaves_like 'application period is over' do
        subject { post :create }
      end

    end

    describe 'PATCH update' do
      let(:team)   { create :team, :in_current_season }
      let!(:draft) { create :application_draft, team: team }

      before do
        create :student_role, user: user, team: team
      end

      it_behaves_like 'application period is over' do
        subject { patch :update, params: { id: draft.to_param } }
      end

      it 'sets the updated_by attibute' do
        expect {
          patch :update, { params: { id: draft.to_param, application_draft: { misc_info: 'Foo!' } } }
        }.to change { draft.reload.updater }.from(nil).to user
        expect(response).to redirect_to [:edit, assigns[:application_draft]]
      end

      it 'will not update an application draft that has already been submitted' do
        allow(draft).to receive(:ready?).and_return(true)
        draft.submit_application(1.hour.ago)
        draft.save

        expect {
          patch :update, { params: { id: draft.to_param, application_draft: { misc_info: 'Foo!' } } }
        }.not_to change { draft.reload.misc_info }
        expect(response).to redirect_to application_drafts_path
      end
    end

    describe 'GET check' do
      let(:team)   { create :team, :in_current_season }
      let!(:draft) { create :application_draft, team: team }

      before do
        create :student_role, user: user, team: team
      end

      context 'for an invalid draft' do
        it 'displays errors' do
          get :check, params: { id: draft.to_param }
          expect(response).to render_template 'new'
          expect(flash[:alert]).to be_present
          expect(response.body).to match /About yourself \(\d{,2} errors\)/
          expect(response.body).to match /About your pair \(\d{,2} errors\)/
          expect(response.body).to match /About your project \(\d{,2} errors\)/
          expect(response.body).to match /About your team \(\d{,2} errors\)/
        end
      end

      context 'for a valid draft' do
        before do
          allow_any_instance_of(ApplicationDraft).to receive(:valid?).with(:apply).and_return(true)
        end

        it 'is go' do
          get :check, params: { id: draft.to_param }
          expect(response).to render_template 'new'
          expect(flash[:notice]).to be_present
        end
      end
    end

    describe 'PUT apply' do
      let(:team)  { create(:team, :applying_team, :in_current_season) }
      let(:draft) { create(:application_draft, :appliable, team: team) }
      let(:application) { Application.last }

      context 'as a student' do
        let(:user) { team.students.first }

        context 'coaches confirmed' do
          it 'creates a new application' do
            expect { put :apply, { params: { id: draft.id } } }.to change { Application.count }.by(1)
            expect(flash[:notice]).to be_present
            expect(response).to redirect_to application_drafts_path
            expect(application.application_draft).to eql draft
          end

          it 'sends 1 mail to orga' do
            expect { put :apply, { params: { id: draft.id } } }.to \
              change { enqueued_jobs.size }.by(1)
          end

          it 'flags the draft as applied' do
            expect { put :apply, { params: { id: draft.id } } }.to \
              change { draft.reload.state }.to('applied')
          end
        end

        context 'coaches not confirmed' do
          before do
            allow_any_instance_of(Team).to receive(:coaches_confirmed?).and_return(false)
          end

          it "fails to apply" do
            expect { put :apply, { params: { id: draft.id } } }.not_to change { Application.count }
            expect(flash[:alert]).to be_present
            expect(response).to redirect_to application_drafts_path
          end
        end
      end

      shared_examples_for 'fails to apply for role' do |role, redirection_to:|
        let!(:role) { create("#{role}_role", user: user, team: team) }

        it "fails to apply as a #{role}" do
          expect { put :apply, { params: { id: draft.id } } }.not_to change { Application.count }
          expect(flash[:alert]).to be_present
          expect(response).to redirect_to redirection_to
        end
      end

      it_behaves_like 'fails to apply for role', :student, redirection_to: '/application_drafts' do
        let(:draft) { create :application_draft, team: team }
      end

      it_behaves_like 'fails to apply for role', :coach,  redirection_to: '/'
      it_behaves_like 'fails to apply for role', :mentor, redirection_to: '/'
    end

  end
end
