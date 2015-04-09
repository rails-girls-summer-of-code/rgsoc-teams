require 'spec_helper'

RSpec.describe ApplicationDraftsController do
  render_views

  let(:team) { create :team }

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
  end

  context 'as an anonymous user' do
    describe 'GET new' do
      it 'renders the "sign_in" template' do
        get :new
        expect(response).to render_template 'sign_in'
      end
    end
  end

  context 'as an authenticated user' do
    let(:user) { create(:user) }

    before do
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    describe 'GET index' do
      let!(:student_role) { FactoryGirl.create :student_role, user: user, team: team }
      let!(:drafts) { FactoryGirl.create_list(:application_draft, 2, team: team) }

      subject do
        get :index
      end

      before do
        subject
      end

      it 'assigns @application_drafts' do
        expect(assigns(:application_drafts)).to match_array(drafts)
      end

      it 'renders index' do
        expect(response).to render_template(:index)
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET new' do
      it 'redirects if not part of a students team' do
        get :new
        expect(response).to redirect_to new_team_path
        expect(flash[:alert]).to be_present
      end

      it 'renders the "new" template for a single team member' do
        create :student_role, user: user
        get :new
        expect(response).to render_template 'new'
        expect(response.body).to \
          match "You haven't got a second student on your team."
      end

      it 'renders the "new" template for a tean with two students' do
        other_role = create :student_role
        create :student_role, user: user, team: other_role.team
        get :new
        expect(response).to render_template 'new'
      end

      it 'redirects to the index action if there are already more than two application drafts' do
        create :student_role, user: user, team: team
        2.times { team.application_drafts.create }

        get :new
        expect(response).to redirect_to application_drafts_path
        expect(flash[:alert]).to be_present
      end
    end

    describe 'GET edit' do
      let(:draft) { create :application_draft }

      it 'redirects if not part of a team' do
        get :edit, id: draft.to_param
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end

      it 'will not find somebody else\'s draft' do
        create :student_role, user: user
        expect {
          get :edit, id: draft.to_param
        }.to raise_error ActiveRecord::RecordNotFound
      end

      shared_examples_for 'reading the application draft form as' do |role|
        before { create "#{role}_role", user: user, team: draft.team }

        context "as a #{role} of the team" do
          it 'renders the new template' do
            get :edit, id: draft.to_param
            expect(response).to render_template 'new'
          end
        end
      end

      it_behaves_like 'reading the application draft form as', :student
      it_behaves_like 'reading the application draft form as', :coach
      it_behaves_like 'reading the application draft form as', :mentor
    end

    describe 'POST create' do
      it 'creates a draft and redirects to edit' do
        create :student_role, user: user
        expect { post :create, application_draft: { misc_info: 'Foo!' } }.to \
          change { ApplicationDraft.count }.by 1
        expect(flash[:notice]).not_to be_nil
        expect(response).to redirect_to [:edit, assigns[:application_draft]]
      end

    end

    describe 'PATCH update' do
      let(:draft) { create :application_draft }

      before do
        create :student_role, user: user, team: draft.team
      end

      it 'sets the updated_by attibute' do
        expect {
          patch :update, id: draft.to_param, application_draft: { misc_info: 'Foo!' }
        }.to change { draft.reload.updater }.from(nil).to user
        expect(response).to redirect_to [:edit, assigns[:application_draft]]
      end

      it 'will not update an application draft that has already been submitted' do
        allow(draft).to receive(:ready?).and_return(true)
        draft.submit_application(1.hour.ago)
        draft.save

        expect {
          patch :update, id: draft.to_param, application_draft: { misc_info: 'Foo!' }
        }.not_to change { draft.reload.misc_info }
        expect(response).to redirect_to application_drafts_path
      end
    end

    describe 'GET check' do
      let(:draft) { create :application_draft }

      before do
        create :student_role, user: user, team: draft.team
      end

      context 'for an invalid draft' do
        it 'displays errors' do
          get :check, id: draft.to_param
          expect(response).to render_template 'new'
          expect(flash[:alert]).to be_present
          expect(response.body).to match 'to go before you can apply'
        end
      end

      context 'for a valid draft' do
        before do
          allow_any_instance_of(ApplicationDraft).to receive(:valid?).with(:apply).and_return(true)
        end

        it 'is go' do
          get :check, id: draft.to_param
          expect(response).to render_template 'new'
          expect(flash[:notice]).to be_present
        end
      end
    end

    describe 'PUT #prioritize' do
      let!(:student_role) do
        FactoryGirl.create(:student_role, user: user, team: team)
      end
      let!(:drafts) { FactoryGirl.create_list(:application_draft, 2, team: team) }

      subject do
        put :prioritize,
            id: drafts.last.id
      end

      before do
        subject
      end

      it 'sets the positions' do
        expect(team.application_drafts.order('position ASC').map(&:id)).to eq [2, 1]
      end
    end

    describe 'PUT apply' do
      let(:team)  { create(:team, :applying_team) }
      let(:draft) { create :application_draft, :appliable, team: team }
      let(:application) { Application.last }

      context 'as a student' do
        let!(:student_role) { create(:student_role, user: user, team: team) }

        it 'creates a new application' do
          expect { put :apply, id: draft.id }.to change { Application.count }.by(1)
          expect(flash[:notice]).to be_present
          expect(response).to redirect_to application_drafts_path
          expect(application.application_draft).to eql draft
        end

        it 'sends a mail' do
          expect { put :apply, id: draft.id }.to \
            change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'flags the draft as applied' do
          expect { put :apply, id: draft.id }.to \
            change { draft.reload.state }.to('applied')
        end
      end

      shared_examples_for 'fails to apply for role' do |role|
        let!(:role) { create("#{role}_role", user: user, team: team) }

        it "fails to apply as a #{role}" do
          expect { put :apply, id: draft.id }.not_to change { Application.count }
          expect(flash[:alert]).to be_present
          expect(response).to redirect_to application_drafts_path
        end
      end

      it_behaves_like 'fails to apply for role', :student do
        let(:draft) { create :application_draft, team: team }
      end

      it_behaves_like 'fails to apply for role', :coach
      it_behaves_like 'fails to apply for role', :mentor
    end

  end
end
